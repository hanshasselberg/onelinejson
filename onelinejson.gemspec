# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onelinejson/version'

Gem::Specification.new do |spec|
  spec.name          = "onelinejson"
  spec.version       = Onelinejson::VERSION
  spec.authors       = ["Hans Hasselberg"]
  spec.email         = ["me@hans.io"]
  spec.summary       = %q{Everything you need to log json oneliners}
  spec.description   = %q{Everything you need to log json oneliners}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "lograge", ">= 0.3.0"
end
