[github]: https://github.com/neopoly/neo-rails
[doc]: http://rubydoc.info/github/neopoly/neo-rails/master/file/README.md
[gem]: https://rubygems.org/gems/neo-rails
[travis]: https://travis-ci.org/neopoly/neo-rails
[codeclimate]: https://codeclimate.com/github/neopoly/neo-rails
[inchpages]: https://inch-ci.org/github/neopoly/neo-rails

# Neo::Rails

`neo-rails` contains some tools helping us doing Rails.

[![Travis](https://img.shields.io/travis/neopoly/neo-rails.svg?branch=master)][travis]
[![Gem Version](https://img.shields.io/gem/v/neo-rails.svg)][gem]
[![Code Climate](https://img.shields.io/codeclimate/github/neopoly/neo-rails.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/neopoly/neo-rails/badges/coverage.svg)][codeclimate]
[![Inline docs](https://inch-ci.org/github/neopoly/neo-rails.svg?branch=master&style=flat)][inchpages]

[Gem][gem] |
[Source][github] |
[Documentation][doc]

This gem includes:
* Mocks
* Presenters
* View Models
* Exposure
* Scenarios

## Installation

Add this line to your application's Gemfile:

    gem 'neo-rails', '~> 0.4.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neo-rails

You can generate base classes for your presenters, mocks and view models with

    $ rake neo-rails:setup

## Usage

### Generators
Create files and tests...

Example 'User':
```ruby
rails g presenter User
```
```ruby
rails g mock User
```
```ruby
rails g view_model UserProfile
```


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

### Exposures

In app/controllers/pages_controller.rb

```ruby
class PagesController < ApplicationController
  include Neo::Rails::Exposure
  
  exposes :title, :description
  
  def faq
    expose :title, "A title"
    expose :description, "A description"
  end
end
```

In app/views/pages/faq.html.erb

```erb
<div class="title">
  <%= title %>
</div>
<div class="description">
  <%= description %>
</div>
```

### Scenarios

In app/assets/stylesheets/application.css:

    /*= require neo-rails */

In app/assets/javascript/application.js

    //= require neo-rails

In app/layouts/application.html.erb

    <%= render_scenarios_list %>

### Testing

    rm -f Gemfile.lock
    export RAILS_VERSION=3.2 # or 4.0
    bundle
    bundle exec rake

## TODO

* Test scenarios!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Release

Follow these steps to release this gem:

    # Bump version in
    edit lib/neo/rails/version.rb
    edit README.md

    git commit -m "Release X.Y.Z"

    rake release
