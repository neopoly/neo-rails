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
          class_attribute :scenarios
          self.scenarios = Hash.new { |hash, action| hash[action] = {} }
          before_filter :apply_scenario
          helper_method :list_scenarios
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
          scenario = Scenario.new(action, name, block, options)

          raise DuplicatedScenario if self.scenarios[scenario.action][scenario.name]

          self.scenarios[scenario.action][scenario.name] = scenario
        end

        def list_scenarios
          self.scenarios.values.map(&:values).flatten
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

      # List all defined scenarios
      #
      # Return an Array of +scenario+ objects
      def list_scenarios
        self.class.list_scenarios
      end

    protected

      # Applies a scenario as a before filter if there is one which fits.
      def apply_scenario
        action_key   = params[:action].to_sym
        scenario_key = params[:scenario].try(:to_sym)
        if scenario_key && (scenario = self.class.scenarios[action_key][scenario_key])
          instance_eval(&scenario.block)
        end
      end

      # Does this controller run a scenario right now?
      def scenario?
        params[:scenario]
      end

      # A simple class encapsulating a scenario:
      # * the corresponding action
      # * the scenario's name
      # * an humanized name as label
      # * the blocked which will be called when applying a scenario
      class Scenario
        attr_reader :action, :name, :block, :options

        def initialize(action, name, block, options)
          @action   = action.to_sym
          @name     = name.to_sym
          @block    = block
          @options  = options
        end

        def label
          "#{@action.to_s.humanize} -> #{@name.to_s.humanize}"
        end
      end
    end
  end
end
