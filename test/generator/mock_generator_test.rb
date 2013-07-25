require 'helper'
require 'generators/mock/mock_generator'

class MockGeneratorTest < GeneratorCase
  tests MockGenerator

  test "create mock" do
    run_generator %w(test)
    
    assert_file "app/mocks/test_mock.rb" do |mock|
      assert_match(/class TestMock < Mock/, mock)
    end

  end

end