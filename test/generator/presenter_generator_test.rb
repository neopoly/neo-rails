require 'helper'
require 'generators/presenter/presenter_generator'

class PresenterGeneratorTest < GeneratorCase
  tests PresenterGenerator

  test "create presenter" do
    run_generator %w(test)
    
    assert_file "app/presenters/test_presenter.rb" do |presenter|
      assert_match(/class TestPresenter < Presenter/, presenter)
      assert_match(/def initialize\(test\)/, presenter)
      assert_match(/@test = test/, presenter)
    end

  end

  test "create presenter test" do 
    run_generator %w(test)
    
    assert_file "test/presenters/test_presenter_test.rb" do |presenter_test|
      assert_match(/require 'test_helper'/, presenter_test)
      assert_match(/class TestPresenterTest < ActiveSupport::TestCase/, presenter_test)
    end
  end

end