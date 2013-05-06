# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'live_resource/activerecord/version'

Gem::Specification.new do |spec|
  spec.name          = "live_resource-activerecord"
  spec.version       = LiveResource::ActiveRecord::VERSION
  spec.authors       = ["Will Madden"]
  spec.email         = ["will@letsgeddit.com"]
  spec.description   = %q{Adds support to LiveRecord for ActiveRecord dependencies}
  spec.summary       = %q{Adds support to LiveRecord for ActiveRecord dependencies}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'live_resource'
  spec.add_dependency 'activerecord'

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
