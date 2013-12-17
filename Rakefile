require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "onelinejson/version"

task :gem => :build
task :build do
  system "gem build onelinejson.gemspec"
end

task :install => :build do
  system "gem install #{FILE}"
end

task :release => :build do
  system "git tag -a v#{Onelinejson::VERSION} -m 'Tagging #{Onelinejson::VERSION}'"
  system "git push --tags"
  system "gem push onelinejson-#{Onelinejson::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.ruby_opts = "-W -I./spec -rspec_helper"
end
task :default => :spec
