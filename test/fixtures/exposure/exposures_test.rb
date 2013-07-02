require 'helper'

require 'neo/rails/exposure/exposures'

class ExposuresTest < NeoRailsCase
  let(:exposures){ Neo::Rails::Exposure::Exposures.new([:a])}

  test "exposed?" do
    refute exposures.exposed?(:a)
    exposures[:a] = nil
    assert exposures.exposed?(:a)
    refute exposures.exposed?(:b)
    exposures[:a] = 1
    assert exposures.exposed?(:a)
    refute exposures.exposed?(:b)
  end

  test "sets and gets a key" do
    exposures[:a] = "foo"
    assert_equal "foo", exposures[:a]
    assert_equal "foo", exposures.a
  end

  test "raises if a undefined key is set" do
    assert_raises Neo::Rails::Exposure::UndeclaredVariableError do
      exposures[:c] = 1
    end
  end
end
