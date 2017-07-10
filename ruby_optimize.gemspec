# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby_optimize/version"

Gem::Specification.new do |s|
  s.name        = 'ruby_optimize'
  s.version     = RubyOptimize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Adriano di Lauro']
  s.email       = ['adr_dilauro@hotmail.it']
  s.homepage    = 'https://github.com/adrdilauro/ruby_optimize'
  s.summary     = 'Tool to implement flexible A/B tests in Ruby on Rails'
  s.description = 'With ruby_optimize you can set up multiple A/B tests, consistent across session, in a clean way and without page flickering'

  s.files = Dir['lib/*.rb'] + Dir['lib/controllers/*.rb'] + Dir['lib/helpers/*.rb']

  s.licenses = ['MIT']

  s.add_dependency 'activesupport', ['>= 3.0.0']
  s.add_dependency 'actionpack', ['>= 3.0.0']
end
