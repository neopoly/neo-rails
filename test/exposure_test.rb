require 'helper'

require 'rack/test'
require 'action_controller/railtie'

require 'neo/rails/exposure'


class ExposureTestController < ActionController::Base
  include Neo::Rails::Exposure

  exposes :a, :b

  def foo
    render :text => "bar"
  end

  def expose_via_value
    expose :a, "a"
    expose :b, "b"
    render :inline => %{ar=#{exposures.a},ah=<%= a %>,br=#{exposures.b},bh=<%= b %>}
  end

  def expose_via_block
    expose(:a) { "a" }
    expose(:b) { "b" }
    render :inline => %{ar=#{exposures.a},ah=<%= a %>,br=#{exposures.b},bh=<%= b %>}
  end

  def exposes_via_value_with_template
    expose(:a, "a")
    expose(:b) { "b" }
    template = File.expand_path(File.join("..", "fixtures", "views", "exposes_via_value_with_template"), __FILE__)
    render :file => template
  end

  def expose_with_error
    expose(:unknown) { "unknown" }
  end

  def expose_nil_value
    expose(:a) { nil }
    render :inline => [ exposed?(:a), exposed?(:b) ].inspect
  end
end

class OtherExposureTestController < ExposureTestController
  include Neo::Rails::Exposure

  exposes :c

  def bar
    expose :a, "a"
    expose :b, "b"
    expose :c, "c"

    render :inline => "<%= a %>;<%= b %>;<%= c %>"
  end

end

class ATestController < ExposureTestController
  exposes :z

  def baz
    expose :z, "z"
    render :inline => "<%= z %>"
  end
end

class BTestController < ExposureTestController
  exposes :z

  def baz
    expose :z, "z"
    render :inline => "<%= z %>"
  end
end

class ExposureTestApp < Rails::Application
  routes.draw do
    ExposureTestController.action_methods.each do |action|
      get action => "exposure_test##{action}"
    end
    get "other/bar" => "other_exposure_test#bar"
    get "a/baz" => "a_test#baz"
    get "b/baz" => "b_test#baz"
  end

  config.secret_key_base = "a" * 32
  config.secret_token = "a" * 32
  config.session_store :disabled
  config.middleware.delete Rails::Rack::Logger
  config.middleware.delete ActionDispatch::ShowExceptions
  config.middleware.delete ActionDispatch::DebugExceptions
end

class ExposureTest < NeoRailsCase
  include Rack::Test::Methods

  def app
    ExposureTestApp
  end

  test "should expose variable per value" do
    get "expose_via_value"
    assert_equal "ar=a,ah=a,br=b,bh=b", last_response.body
  end

  test "should expose variable per block" do
    get "expose_via_block"
    assert_equal "ar=a,ah=a,br=b,bh=b", last_response.body
  end

  test "should expose variable per value with template" do
    get "exposes_via_value_with_template"
    assert_equal "ah=a,bh=b", last_response.body
  end


  test "should raise an error when exposing an undeclared variable" do
    assert_raises Neo::Rails::Exposure::UndeclaredVariableError do
      get "expose_with_error"
    end
  end

  test "exposes nil value" do
    get "expose_nil_value"
    assert_equal [ true, false ].inspect, last_response.body
  end

  test "exposes vars in subclass" do
    get "other/bar"
    assert_equal "a;b;c", last_response.body
  end

  test "exposes var in subclass parallel" do
    get "a/baz"
    assert_equal "z", last_response.body

    get "b/baz"
    assert_equal "z", last_response.body
  end
end
