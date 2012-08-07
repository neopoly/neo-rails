require 'active_support/concern'

module Neo
  module Rails
    module Scenarios
      # Useful test helpers for minitest (test/unit).
      #
      # == Usage
      #
      #   require 'neo/rails/scenarios/test_helper'
      #
      #   class ActionController::TestCase
      #     include Neo::Rails::Scenarios::TestHelper
      #   end
      #
      module TestHelper
        extend ActiveSupport::Concern

        module ClassMethods
          # Creates test methods for each defined scenario defined in controller.
          def test_scenarios(options={})
            controller_class = options.delete(:controller) || self.controller_class
            raise "no controller_class defined? Use 'tests MyController'" unless controller_class
            return unless controller_class.respond_to?(:list_scenarios)
            scenarios = controller_class.list_scenarios

            if except = options.delete(:except)
              except = Set.new(Array(except))
              scenarios.reject! { |scenario| except.include?(scenario.name) }
            end

            return if scenarios.empty?

            scenarios.each do |scenario|
              method        = scenario.options[:method] || :get
              path          = scenario.action
              scenario_name = scenario.name

              test "test scenario #{controller_class}##{method} #{path.inspect}, :scenario => #{scenario_name.inspect}" do

                send(method, path, :id => 1, :scenario => scenario_name)
                assert_response :success
              end
            end
          end
        end
      end
    end
  end
end
