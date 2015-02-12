source 'https://rubygems.org'

# Specify your gem's dependencies in neo-rails.gemspec
gemspec

rails_version = ENV['RAILS_VERSION']
case rails_version
when /^(\d+\.\d+)/
  gem 'rails', "~> #{$1}.0"
when NilClass
  abort "Missing env RAILS_VERSION"
else
  abort "Rails version #{rails_version.inspect} not supported"
end

if ENV['CODECLIMATE_REPO_TOKEN']
  gem "codeclimate-test-reporter", :group => :test, :require => nil
end
