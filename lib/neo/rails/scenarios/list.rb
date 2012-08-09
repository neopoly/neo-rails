module Neo
  module Rails
    module Scenarios
      class List
        include Enumerable

        def initialize
          @scenarios = {}
        end

        def find(controller, action, name)
          identifier = Scenario.identifier(controller, action, name)
          @scenarios[identifier]
        end

        def <<(scenario)
          identifier = scenario.identifier
          raise DuplicatedScenario if @scenarios.key?(identifier)
          @scenarios[identifier] = scenario
        end

        def each(&block)
          @scenarios.values.each(&block).sort
        end

        def any?
          @scenarios.any?
        end

        def preloaded
          self
        end
      end
    end
  end
end
