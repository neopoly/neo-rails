require 'helper'

require 'neo/rails/scenarios'
require 'neo/rails/scenarios/middleware'

class ScenarioPresenterTest < NeoRailsCase
  let(:scenario)  { Neo::Rails::Scenarios::Scenario.new(:foo, :bar, :nil, :method => :post) }
  let(:presenter) { Neo::Rails::Scenarios::ScenarioPresenter.new(scenario) }

  class ViewContext
    def link_to(path, name, options= {})
      %{<a href="#{path}">#{name}</a>}
    end

    def url_for(*args)
      "/foo/bar"
    end
  end

  before do
    Neo::Rails::Presenter.view_context = ViewContext.new
  end

  context "presenter" do
    test "delegates" do
      assert_equal scenario.action, presenter.action
      assert_equal scenario.name, presenter.name
      assert_equal scenario.options, presenter.options
    end

    test "build label" do
      assert_match %r(\A\w+\s+.+\s+\w+\Z), presenter.label
    end

    test "build link" do
      assert_match %r(\A\<.+\/foo\/bar), presenter.link
    end
  end

  context "middleware" do
    let(:env)          { Hash.new }

    class DummyApplication
      def initialize(content_type = 'text/html', scenario_presenters = nil)
        @content_type, @scenario_presenters = content_type, scenario_presenters
      end

      def call(env)
        env[Neo::Rails::Scenarios::ENV_KEY] = @scenario_presenters
        [200, {'Content-Type' => @content_type}, ["<html><head></head><body>CONTENT</body></html>"] ]
      end
    end

    test "pass through response when no scenarios" do
      middleware = Neo::Rails::Scenarios::Middleware.new(DummyApplication.new)
      status, headers, response = middleware.call(env)
      assert_equal "<html><head></head><body>CONTENT</body></html>", response.first
    end

    context "with scenarios content type not html" do
      test "pass through response for json" do
        middleware = Neo::Rails::Scenarios::Middleware.new(DummyApplication.new('application/json', [presenter]))
        status, headers, response = middleware.call(env)
        assert_equal "<html><head></head><body>CONTENT</body></html>", response.first
      end

      test "pass through response for nil" do
        middleware = Neo::Rails::Scenarios::Middleware.new(DummyApplication.new(nil, [presenter]))
        status, headers, response = middleware.call(env)
        assert_equal "<html><head></head><body>CONTENT</body></html>", response.first
      end
    end

    context "with scenarios and content type html" do
      let(:middleware) { Neo::Rails::Scenarios::Middleware.new(DummyApplication.new('text/html', [presenter])) }

      test "pass through status and headers" do
        status, headers, response = middleware.call(env)
        assert_equal 200, status
        assertion = {'Content-Type' => 'text/html'}
        assert_equal assertion, headers
      end

      test "inject js" do
        status, headers, response = middleware.call(env)
        assert_match %r(\<script.+\>), response.first
      end

      test "inject style" do
        status, headers, response = middleware.call(env)
        assert_match %r(\<style.+\>), response.first
      end

      test "inject html" do
        status, headers, response = middleware.call(env)
        assert_match %r(\<div.+class='neo-rails-scenarios-list'\>), response.first
      end
    end
  end
end
