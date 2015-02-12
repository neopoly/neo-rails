if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simplecov' if ENV['COVERAGE']
require 'rails/generators'
require 'minitest/autorun'

class NeoRailsCase < MiniTest::Spec
  class << self
    alias :context :describe
    alias :test :it
  end
end

class GeneratorCase < Rails::Generators::TestCase
  destination File.expand_path("../../tmp", File.dirname(__FILE__))
  setup :prepare_destination
end
