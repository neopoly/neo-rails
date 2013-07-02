require 'helper'

require 'neo/rails/exposure/exposures'

class ExposureExposuresTest < NeoRailsCase
  let(:exposure_names) { [:a] }
  let(:exposures) { Neo::Rails::Exposure::Exposures.new(exposure_names) }

  test "exposed? with value" do
    refute exposures.exposed?(:a)
    exposures[:a] = 1
    assert exposures.exposed?(:a)
  end

  test "exposed? with nil" do
    refute exposures.exposed?(:a)
    exposures[:a] = nil
    assert exposures.exposed?(:a)
  end

  test "exposed? for undeclared exposure" do
    refute exposures.exposed?(:b)
  end

  test "sets and gets a key" do
    exposures[:a] = "foo"
    assert_equal "foo", exposures[:a]
    assert_equal "foo", exposures.a
  end

  test "raises if a undefined key is set" do
    assert_raises Neo::Rails::Exposure::UndeclaredVariableError do
      exposures[:b] = 1
    end
  end
end
