# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deviant/version'

Gem::Specification.new do |spec|
  spec.name          = "deviant"
  spec.version       = Deviant::VERSION
  spec.authors       = ["Ryan LeFevre"]
  spec.email         = ["ryan@layervault.com"]
  spec.description   = %q{Elasticsearch backed exception logging}
  spec.summary       = %q{Elasticsearch backed exception logging}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq"
  spec.add_dependency "tire"
  spec.add_dependency "yajl-ruby"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
