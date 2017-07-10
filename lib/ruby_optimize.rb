module RubyOptimize
end

begin
  require 'rails'
rescue LoadError
end

require 'ruby_optimize/common_controllers_and_helpers'
require 'ruby_optimize/controllers/action_controller_extension'
require 'ruby_optimize/helpers/action_view_extension'
require 'ruby_optimize/models/ab_test_handler'
require 'ruby_optimize/hooks'

if defined? Rails
  require 'ruby_optimize/railtie'
end
