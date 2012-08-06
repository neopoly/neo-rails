module Neo
  module Rails
    class Engine < ::Rails::Engine
      initializer "neo-rails.scenarios_helpers" do
        require 'neo/rails/scenarios/rails_helper'

        ActiveSupport.on_load(:action_view) do
          include Neo::Rails::Scenarios::RailsHelper
        end
      end
    end
  end
end
