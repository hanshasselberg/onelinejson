require "onelinejson/version"
require 'json'
require 'lograge'

require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

module Onelinejson
  module AppControllerMethods
    def append_info_to_payload(payload)
      super
      headers = if request.headers.respond_to?(:env)
        request.headers.env
      elsif request.headers.respond_to?(:to_hash)
        request.headers.to_hash
      end.reject do |k, v|
        !k.starts_with?("HTTP_") || k == "HTTP_AUTHORIZATION"
      end
      parameters = params.reject do |k,v|
        k == 'controller' ||
          k == 'action' ||
          v.is_a?(ActionDispatch::Http::UploadedFile)
      end

      payload[:request] = {
        params: parameters,
        headers: headers,
        ip: request.ip,
        uuid: request.env['action_dispatch.request_id'],
        controller: self.class.name,
        date: Time.now.utc.iso8601,
      }
      u_id = @current_user_id || (@current_user && @current_user.id)
      if u_id.present?
        payload[:request][:user_id] = u_id.to_i
      end
    end
  end

  class Railtie < Rails::Railtie
    config.lograge = ActiveSupport::OrderedOptions.new
    config.lograge.formatter = ::Lograge::Formatters::Json.new
    config.lograge.enabled = true
    config.lograge.before_format = lambda do |data, payload|
      request = data.select{ |k,_|
        [:method, :path, :format, :controller, :action].include?(k)
      }.merge(payload[:request])
      response = data.select{ |k,_|
        [:status, :duration, :view, :view_runtime].include?(k)
      }
      {
        debug_info: payload[:debug_info] || {},
        request: request,
        response: response,
      }
    end

    ActiveSupport.on_load(:action_controller) do
      include AppControllerMethods
    end
  end
end
