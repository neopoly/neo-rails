require 'helper'

require 'neo/rails/mock'

class MockTest < NeoRailsCase
  context :tagged do
    let(:mock) { Neo::Rails::Mock.new(:foo, :bar) }

    test "has mock_description" do
      assert_equal "Foo, Bar", mock.mock.description
    end

    test "mock_tagged?" do
      assert mock.mock.tagged?(:foo)
      assert mock.mock.tagged?(:foo)
      assert mock.mock.tagged?(:bar)
      refute mock.mock.tagged?(:baz)
    end
  end

  context :untagged do
    let(:mock) { Neo::Rails::Mock.new }

    test "has empty mock_description" do
      assert_equal "", mock.mock.description
    end

    test "is not mock_tagged?" do
      refute mock.mock.tagged?(:foo)
      refute mock.mock.tagged?(:bar)
    end
  end
end
