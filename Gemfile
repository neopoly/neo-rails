source 'https://rubygems.org'

# Specify your gem's dependencies in neo-rails.gemspec
gemspec

rails_version = ENV['RAILS_VERSION']
case rails_version
when '4.1.6'
  gem 'rails', '~> 4.1.6'
when '4.1'
  gem 'rails', '~> 4.1.0'
when '4.0'
  gem 'rails', '~> 4.0.0'
when '3.2'
  gem 'rails', '~> 3.2.13'
when NilClass
  abort "Missing env RAILS_VERSION"
else
  abort "Rails version #{rails_version.inspect} not supported"
end

if ENV['CODECLIMATE_REPO_TOKEN']
  gem "codeclimate-test-reporter", :group => :test, :require => nil
end
