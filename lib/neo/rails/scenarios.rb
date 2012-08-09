require 'active_support/core_ext/class'
require 'active_support/concern'

module Neo
  module Rails
    # Enables controller actions to have scenarios, which will be applied
    # +before+ the execution of the action.
    module Scenarios
      extend ActiveSupport::Concern

      class DuplicatedScenario < StandardError; end
      class ExposureMustBeIncludedFirst < StandardError; end

      included do
        if self < Neo::Rails::Exposure
          cattr_accessor :scenarios
          self.scenarios = List.new
          prepend_before_filter :apply_scenario
          helper_method :scenarios
        else
          raise ExposureMustBeIncludedFirst
        end
      end

      module ClassMethods
        # Defines a scenario
        #
        # == Usage
        #
        #   class AController < ActionController::Base
        #     include Neo::Rails::Exposure
        #     include Neo::Rails::Scenarios
        #
        #     exposes :foo
        #
        #     def show
        #       ...
        #     end
        #
        #     scenario :show, :a_scenario do
        #       expose :foo, "bar" # any expose calls on :foo will be ignored in the action
        #     end
        #   end
        #
        # Raises DuplicatedScenario if there is already a scenario for the action with the same name
        #
        def scenario(action, name, options={}, &block)
          scenario = Scenario.new(self, action, name, block, options)
          scenarios << scenario
        end

        def scenarios(&block)
          if block
            scenarios.define(&block)
          else
            self.scenarios
          end
        end
      end

      # Overwrites expose so it will only set the value once.
      # see Neo::Rails::Exposure
      def expose(name, value=nil)
        if exposed?(name)
          # nothing as set already via mock
        else
          super
        end
      end

      def scenarios
        self.class.scenarios
      end

    protected

      # Applies a scenario as a before filter if there is one which fits.
      def apply_scenario
        if scenario = self.class.scenarios.find(controller_name, params[:action], params[:scenario])
          instance_eval(&scenario.block)
        end
      end

      # Does this controller run a scenario right now?
      def scenario?
        params[:scenario]
      end
    end
  end
end
