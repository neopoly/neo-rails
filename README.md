# Neo::Rails [![Build Status](https://secure.travis-ci.org/neopoly/neo-rails.png?branch=master)](http://travis-ci.org/neopoly/neo-rails)
`neo-rails` contains some tools helping us doing Rails.

This gem includes:
* Mocks
* Presenters
* Exposure
* Scenarios

## Installation

Add this line to your application's Gemfile:

    gem 'neo-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neo-rails

## Usage

### Presenter

In app/presenters/presenter.rb

```ruby
class Presenter
  include Neo::Rails::Presenter
end

class UserPresenter < Presenter
  def initialize(user)
    @user = user
  end

  def name
    @user.name
  end

  def profile_path
    view_context.link_to view_context.user_profile_path(@user), name
  end
end
```

In test/test_helper.rb

```ruby
require 'neo/rails/presenter/test_helper'

Neo::Rails::Presenter::TestHelper.setup
```

### Scenarios

Use scenarios to test different states of your views per action. You can use mocks to provide data and it is design to work with exposures. Exposures which are prefilled in the scenario description will be ignored when the action
is executed. This works best when using blocks for exposures which will not be called:

```ruby
class DummyController < ApplicationController
  include Neo::Rails::Exposure
  include Neo::Rails::Scenarios

  exposes :team

  def index
    expose(:team) do
      TeamPresenter.new(current_user.team) if current_user.team?
    end
  end

  scenario(:index, :without_team) do
    expose :team, nil
  end

  scenario(:index, :with_team)  do
    expose :team, TeamPresenter.new(TeamMock.new)
  end
end
```

When scenarios are available a list of them will be displayed in the browser when running in development mode, so you can design your views without real business data.

You can test all your scenarios of one controller by using a test helper:

```ruby
require 'neo/rails/scenarios/test_helper'

class DummyControllerTest < ActionController::TestCase
  include Neo::Rails::Scenarios::TestHelper
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
