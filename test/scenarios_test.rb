require 'helper'

require 'neo/rails/scenarios'

class ScenarioPresenterTest < NeoRailsCase
  context "presenter" do
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

    let(:scenario)  { Neo::Rails::Scenarios::Scenario.new(:foo, :bar, :nil, :method => :post) }
    let(:presenter) { Neo::Rails::Scenarios::ScenarioPresenter.new(scenario) }
    test "delegates" do
      assert_equal scenario.action, presenter.action
      assert_equal scenario.name, presenter.name
      assert_equal scenario.options, presenter.options
    end

    test "build label" do
      assert_match %r(\A\w+\s+->\s+\w+\Z), presenter.label
    end

    test "build link" do
      assert_match %r(\A\<.+\/foo\/bar), presenter.link
    end
  end
end
