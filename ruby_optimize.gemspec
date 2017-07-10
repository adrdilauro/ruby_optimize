# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_optimize/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_optimize'
  spec.version       = RubyOptimize::VERSION
  spec.authors       = ['Adriano di Lauro']
  spec.email         = ['adr_dilauro@hotmail.it']
  spec.summary       = 'Tool to implement flexible A/B tests in Ruby on Rails'
  spec.description   = 'With ruby_optimize you can set up multiple A/B tests, consistent across session, in a clean way and without page flickering'
  spec.homepage      = 'https://github.com/adrdilauro/ruby_optimize'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', ['>= 3.0.0']
  spec.add_dependency 'actionpack', ['>= 3.0.0']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
