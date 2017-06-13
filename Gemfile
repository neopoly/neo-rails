source 'https://rubygems.org'

# Specify your gem's dependencies in neo-rails.gemspec
gemspec

case ENV['RAILS_VERSION']
when /^(\d+\.\d+)/
  gem 'rails', "~> #{$1}.0"
else
  gem 'rails'
end

group :test do
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end
