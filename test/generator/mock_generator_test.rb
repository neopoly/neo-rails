require 'helper'
require 'rails/generators'
require 'generators/mock/mock_generator'

class MockGeneratorTest < Rails::Generators::TestCase
  tests MockGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "create mock" do
    run_generator %w(test)
    
    assert_file "app/mocks/test_mock.rb" do |mock|
      assert_match(/class TestMock < Mock/, mock)
    end

  end

end