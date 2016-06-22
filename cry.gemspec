# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cry/version'

Gem::Specification.new do |spec|
  spec.name          = "cry"
  spec.version       = Cry::VERSION
  spec.authors       = ["Matt Powell"]
  spec.email         = ["fauxparse@gmail.com"]

  spec.summary       = %q{Publish arbitrary events from inside any Ruby object}
  spec.description   = %q{Ridiculously simple interface for subscribing to arbitrary events on your objects and executing callbacks.}
  spec.homepage      = "https://github.com/fauxparse/cry"
  spec.license       = "MIT"

  spec.files         = %w(lib/cry.rb lib/cry/version.rb)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
