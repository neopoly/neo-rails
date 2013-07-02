require 'active_support/concern'
require 'neo/rails/exposure/exposures'

module Neo
  module Rails
    # A really simple version of exposing variables to the view.
    # Bases on attr_reader and helper_method.
    module Exposure
      extend ActiveSupport::Concern

      included do
        class_attribute :exposure_names
        self.exposure_names ||= Set.new
      end

      def exposures
        @exposures ||= Exposures.new(self.class.exposure_names)
      end

      module ClassMethods
        # Defines the variables to be exposed.
        def exposes(*names)
          exposure_names = names.map(&:to_sym)
          self.exposure_names.merge exposure_names

          # Define a helper method for each exposure
          exposure_names.each do |exposure_name|
            # see Rails: /actionpack/lib/abstract_controller/helpers.rb
            helper do
              define_method exposure_name do
                controller.exposures[exposure_name]
              end
            end
          end
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
        value = yield if block_given?
        self.exposures[key] = value
      end

      private

      def exposed?(key)
        self.exposures.exposed?(key)
      end
    end
  end
end
