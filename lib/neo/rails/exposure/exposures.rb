require 'neo/rails/exposure/errors'

module Neo
  module Rails
    module Exposure
      # Stores the concrete exposures per request
      class Exposures
        extend Forwardable

        def_delegator :@store, :[]
        def_delegator :@store, :key?, :exposed?

        def initialize(names)
          @names = names
          @store = Hash.new
        end

        def []=(key, value)
          raise UndeclaredVariableError unless @names.include?(key)
          @store[key] = value
        end

        def method_missing(method_name, *args)
          if exposed?(method_name)
            @store[method_name]
          else
            super
          end
        end

      end
    end
  end
end
