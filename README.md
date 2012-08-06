# Neo::Rails

TODO: Write a gem description

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

In test/test_helper.rb

    require 'neo/rails/presenter/test_helper'

    Neo::Rails::Presenter::TestHelper.setup

### Scenarios

In app/assets/stylesheets/application.css:

    //= require neo-rails

In app/layouts/application.html.haml

    = render_scenarios_list

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
