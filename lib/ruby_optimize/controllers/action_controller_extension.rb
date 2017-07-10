module RubyOptimize
  module ActionControllerExtension
    def ruby_optimize(versions, **params)
      @ruby_optimize = {} if @ruby_optimize.nil?
      scope = params[:scope] || :default
      raise "RubyOptimize - scope already defined: #{scope.inspect}" if @ruby_optimize.has_key?(scope)
      @ruby_optimize[scope] = AbTestHandler.new(versions, scope, request.user_agent, params[:cookie_expiration], params[:version_for_crawler])
    end
  end
end