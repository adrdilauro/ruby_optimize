module RubyOptimize
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, RubyOptimize::ActionViewExtension
      end

      ActionPack.on_load(:action_controller) do
        ::ActionController::Base.send :include, RubyOptimize::ActionControllerExtension
      end
    end
  end
end
