# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_optimize/version'

Gem::Specification.new do |s|
  s.name          = 'ruby_optimize'
  s.version       = RubyOptimize::VERSION
  s.authors       = ['Adriano di Lauro']
  s.email         = ['adr_dilauro@hotmail.it']
  s.summary       = 'Tool to implement flexible A/B tests in Ruby on Rails'
  s.description   = 'With ruby_optimize you can set up multiple A/B tests, consistent across session, in a clean way and without page flickering'
  s.homepage      = 'https://github.com/adrdilauro/ruby_optimize'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', ['>= 3.0.0']
  s.add_dependency 'actionpack', ['>= 3.0.0']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
