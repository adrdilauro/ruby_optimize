module RubyOptimize
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, RubyOptimize::ActionViewExtension
        ::ActionController::Base.send :include, RubyOptimize::ActionControllerExtension
      end
    end
  end
end
