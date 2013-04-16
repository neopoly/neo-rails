require 'active_support/concern'

module Neo
  module Rails
    # A really simple version of exposing variables to the view.
    # Bases on attr_reader and helper_method.
    module Exposure
      extend ActiveSupport::Concern

      class UndeclaredVariableError < StandardError; end

      included do
        class_attribute :exposed_vars
        self.exposed_vars ||= Set.new
      end

      module ClassMethods
        # Defines the variables to be exposed.
        def exposes(*names)
          exposures = names.map(&:to_sym)
          self.exposed_vars.merge exposures
          attr_reader *exposures
          helper_method *exposures
        end
      end

      # Expose an assign at the instance level.
      #
      # If the value is given with a block, just execute the block
      # if a value was not set yet.
      #
      # Raise UndeclaredVariableError if access variable wasn't declared before.
      def expose(key, value=nil)
        name = key.to_sym
        raise UndeclaredVariableError unless self.class.exposed_vars.include?(name)

        value = yield if block_given?

        self.instance_variable_set("@#{name}", value)
      end

      private

      def exposed?(name)
        instance_variable_defined?("@#{name}")
      end
    end
  end
end
