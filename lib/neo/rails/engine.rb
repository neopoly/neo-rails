module Neo
  module Rails
    class Engine < ::Rails::Engine
      initializer "neo-rails.scenarios_helpers" do
        require 'neo/rails/scenarios/rails_helper'

        ActiveSupport.on_load(:action_view) do
          include Neo::Rails::Scenarios::RailsHelper
        end
      end

      initializer "neo-rails.presenter_method" do
        ActiveSupport.on_load(:action_controller) do
          before_action do |controller|
            Neo::Rails::Presenter.view_context = controller.view_context
          end
        end
      end
    end
  end
end
