require 'set'

# A Mock can fake an object.
#
# This is useful when frontend developers want to fill a page with
# mock data. Mocks can pre-define interface for real data.
# 
# == Usage
#
# app/mocks/user_mock.rb:
#
#   class UserMock < Neo::Rails::Mock
#     def age
#       mock.tagged?(:old) ? 78 : 23
#     end
#
#     def name
#       "Uncle bob"
#     end
#
#     def logged_in?
#       true
#     end
#
#     def sexy?
#       mock.tagged?(:sexy)
#     end
#   end
#
# Further...
#
#   old_man = UserMock.new(:old)
#   old_man.age # => 78
#   old_man.name # => "Uncle Bob"
#
#   old_sexbomb = UserMock.new(:old, :sexy)
#   old_sexbomb.age # => 78
#   old_sexbomb.sexy? # => true
#
module Neo
  module Rails
    class Mock
      attr_reader :mock

      # Initializes a Mock with optional tag list.
      def initialize(*args)
        @mock = MockConfig.new(args)
      end

      class MockConfig
        def initialize(args)
          @tags = args
        end

        # Returns a human readable tag list.
        def description
          @tags.to_a.map { |tag| tag.to_s.capitalize }.join(", ")
        end

        # Checks if this mock is tagged with +tag+.
        def tagged?(tag)
          @tags.include?(tag)
        end
      end
    end
  end
end
