module Neo
  module Rails
    module Scenarios
      # A simple class encapsulating a scenario:
      # * the corresponding action
      # * the scenario's name
      # * an humanized name as label
      # * the blocked which will be called when applying a scenario
      class Scenario
        include Comparable

        attr_reader :controller, :action, :name, :block, :options

        def initialize(controller, action, name, block, options)
          @controller = controller.controller_name.to_sym
          @action     = action.to_sym
          @name       = name.to_sym
          @block      = block
          @options    = options
        end

        def identifier
          self.class.identifier(@controller, @action, @name)
        end

        def self.identifier(controller, action, name)
          [ controller, action, name ].join("-")
        end

        def label
          "#{@controller}##{@action.to_s.humanize}: #{@name.to_s.humanize}"
        end

        def <=>(other)
          identifier <=> other.identifier
        end
      end
    end
  end
end
