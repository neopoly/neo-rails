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

  context :options do
    let(:mock) { Neo::Rails::Mock.new(:tag, :opt => true, "string" => :yes) }

    test "passes options" do
      assert_equal true, mock.mock.option(:opt)
      assert_equal :yes, mock.mock.option("string")

      refute mock.mock.option("opt")
      refute mock.mock.option(:unknown)
    end

    test "is tagged" do
      assert mock.mock.tagged?(:tag)
      assert_equal "Tag", mock.mock.description
    end
  end
end
