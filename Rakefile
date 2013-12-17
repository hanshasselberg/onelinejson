require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "onelineversion/version"

task :gem => :build
task :build do
  system "gem build onelineversion.gemspec"
end

task :install => :build do
  system "gem install #{FILE}"
end

task :release => :build do
  system "git tag -a v#{Onelineversion::VERSION} -m 'Tagging #{Onelineversion::VERSION}'"
  system "git push --tags"
  system "gem push typhoeus-#{Onelineversion::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.ruby_opts = "-W -I./spec -rspec_helper"
end
task :default => :spec
