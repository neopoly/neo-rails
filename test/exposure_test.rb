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
    expose(:unknown) { "unknown" }
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
    get ":action" => ExposureTestController
    get "other/:action" => OtherExposureTestController
    get "a/:action" => ATestController
    get "b/:action" => BTestController
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
