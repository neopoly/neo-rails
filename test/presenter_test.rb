require 'helper'

require 'neo/rails/presenter'

class PresenterTest < NeoRailsCase
  User = Struct.new(:name, :team)
  Team = Struct.new(:name)

  class BasePresenter
    include Neo::Rails::Presenter
  end

  class UserPresenter < BasePresenter
    def initialize(user)
      @user = user
    end

    def name
      @user.name
    end

    def team
      @team ||= TeamPresenter.new(@user.team)
    end

    def link
      view_context.link_to "/user/#{name}", name
    end
  end

  class TeamPresenter < BasePresenter
    def initialize(team)
      @team = team
    end

    def name
      @team.name
    end

    def link
      view_context.link_to "/team/#{name}", name
    end
  end

  class ViewContext
    def link_to(path, name)
      %{<a href="#{path}">#{name}</a>}
    end
  end

  before do
    Neo::Rails::Presenter.view_context = ViewContext.new
  end

  let(:team) { Team.new("A-Team") }
  let(:user) { User.new("Mr T.", team) }

  context "with user_presenter" do
    let(:user_presenter) { UserPresenter.new(user) }

    test "creates a presenter providing current view_context" do
      assert_instance_of ViewContext, user_presenter.view_context
    end

    test "shares view_context with sub presenters" do
      assert_same user_presenter.view_context, user_presenter.team.view_context
    end

    test "uses view_context's methods" do
      assert user_presenter.link
      assert user_presenter.team.link
    end
  end
end
