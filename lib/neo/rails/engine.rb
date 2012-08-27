module Neo
  module Rails
    class Engine < ::Rails::Engine

      initializer "neo-rails.scenario_middleware" do |app|
        require 'neo/rails/scenarios/middleware'

        app.middleware.use Neo::Rails::Scenarios::Middleware
      end

      initializer "neo-rails.presenter_method" do
        ActiveSupport.on_load(:action_controller) do
          before_filter do |controller|
            Neo::Rails::Presenter.view_context = controller.view_context
          end
        end
      end
    end
  end
end
