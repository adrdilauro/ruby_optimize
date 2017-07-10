module RubyOptimize
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'ruby_optimize' do |_app|
      RubyOptimize::Hooks.init
    end
  end
end
