source 'https://rubygems.org'

# Specify your gem's dependencies in neo-rails.gemspec
gemspec

case ENV['RAILS_VERSION']
when /^(\d+\.\d+)/
  gem 'rails', "~> #{$1}.0"
else
  gem 'rails'
end

if ENV['CODECLIMATE_REPO_TOKEN']
  gem "codeclimate-test-reporter", :group => :test, :require => nil
end
