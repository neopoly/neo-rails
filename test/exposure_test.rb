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
    render :inline => %{ar=#{a},ah=<%= a %>,br=#{b},bh=<%= b %>}
  end

  def expose_via_block
    expose(:a) { "a" }
    expose(:b) { "b" }
    render :inline => %{ar=#{a},ah=<%= a %>,br=#{b},bh=<%= b %>}
  end

  def expose_with_error
    expose(:c) { "c" }
  end
end

class ExposureTestApp < Rails::Application
  routes.draw do
    match ":action" => ExposureTestController
  end

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
    get :expose_via_value
    assert_equal "ar=a,ah=a,br=b,bh=b", last_response.body
  end

  test "should expose variable per block" do
    get :expose_via_block
    assert_equal "ar=a,ah=a,br=b,bh=b", last_response.body
  end

  test "should raise an error when exposing an undeclared variable" do
    assert_raises Neo::Rails::Exposure::UndeclaredVariableError do
      get :expose_with_error
    end
  end
end
