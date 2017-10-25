module RubyOptimize
  module ActionViewExtension
    include CommonControllersAndHelpers

    def ruby_optimize_wrap(*version_and_scope, **params, &block)
      scope = version_and_scope[1] || :default
      raise "RubyOptimize - A/B test not initialized" if @ruby_optimize.nil?
      raise "RubyOptimize - scope not found: #{scope.inspect}" if !@ruby_optimize.has_key?(scope)
      @ruby_optimize[scope].wrap(capture(&block), version_and_scope[0], !!params[:version_for_crawler])
    end
  end
end
