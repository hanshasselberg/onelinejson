require "onelinejson/version"
require 'json'
require 'lograge'

require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

module Onelinejson
  class TestSubscriber < ActiveSupport::LogSubscriber
    def process_action(event)
      return if ::Lograge.ignore?(event)

      data = {
        request: {},
        response: {},
        debug_info: {}
      }
      payload = event.payload

      data[:request].merge! extract_request(payload)
      data[:response].merge! extract_status(payload)
      data[:response].merge! runtimes(event)
      data[:response].merge! location(event)
      data.merge! custom_options(event)

      formatted_message = ::Lograge.formatter.call(data)
      logger.send(::Lograge.log_level, formatted_message)
    end

    def redirect_to(event)
      Thread.current[:lograge_location] = event.payload[:location]
    end

    def logger
      ::Lograge.logger.presence or super
    end

    private

    def extract_request(payload)
      Hash[{
        :method => payload[:method],
        :path => extract_path(payload),
        :format => extract_format(payload),
        :controller => payload[:params]['controller'],
        :action => payload[:params]['action'],
      }.merge(payload[:request]).sort]
    end

    def extract_path(payload)
      payload[:path].split("?").first
    end

    def extract_format(payload)
      if ::ActionPack::VERSION::MAJOR == 3 && ::ActionPack::VERSION::MINOR == 0
        payload[:formats].first
      else
        payload[:format]
      end
    end

    def extract_status(payload)
      if payload[:status]
        { :status => payload[:status].to_i }
      elsif payload[:exception]
        exception, message = payload[:exception]
        { :status => 500, :error => "#{exception}:#{message}" }
      else
        { :status => 0 }
      end
    end

    def custom_options(event)
      ::Lograge.custom_options(event) || {}
    end

    def runtimes(event)
      {
        :duration => event.duration,
        :view => event.payload[:view_runtime],
        :db => event.payload[:db_runtime]
      }.inject({}) do |runtimes, (name, runtime)|
        runtimes[name] = runtime.to_f.round(2) if runtime
        runtimes
      end
    end

    def location(event)
      if location = Thread.current[:lograge_location]
        Thread.current[:lograge_location] = nil
        { :location => location }
      else
        {}
      end
    end
  end

  module AppControllerMethods
    def append_info_to_payload(payload)
      super
      payload[:request] = {
        params: params.reject { |k,v|
          k == 'controller' || k == 'action' || v.is_a?(ActionDispatch::Http::UploadedFile)
        },
        headers: request.headers.env.reject {|k, v| !k.starts_with?("HTTP_") || k == "HTTP_AUTHORIZATION"},
        ip: request.ip,
        uuid: request.env['action_dispatch.request_id'],
        controller: self.class.name,
        date: Time.now.utc.iso8601,
      }
      payload[:request][:user_id] = current_user.id if defined?(current_user) && current_user
    end
  end

  class JsonFormatter
    def call(data)
      ::JSON.dump(data)
    end
  end

  class Railtie < Rails::Railtie
    config.lograge = ActiveSupport::OrderedOptions.new
    config.lograge.subscriber = TestSubscriber
    config.lograge.formatter = JsonFormatter.new
    config.lograge.enabled = true

    ActiveSupport.on_load(:action_controller) do
      include AppControllerMethods
    end
  end
end
