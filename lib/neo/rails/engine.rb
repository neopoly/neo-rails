module Neo
  module Rails
    class Engine < ::Rails::Engine
      initializer "neo-rails.scenarios_helpers" do
        ApplicationController.class_eval do
          require 'neo/rails/scenarios/rails_helper'
          helper Neo::Rails::Scenarios::RailsHelper
        end
      end
    end
  end
end
