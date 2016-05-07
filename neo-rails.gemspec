# -*- encoding: utf-8 -*-
require File.expand_path('../lib/neo/rails/version', __FILE__)

rails_version = ENV['RAILS_VERSION']

Gem::Specification.new do |gem|
  gem.authors       = ["Jonas Thiel", "Peter Suschlik"]
  gem.email         = ["jt@neopoly.de", "ps@neopoly.de"]
  gem.description   = %q{Some Rails helpers}
  gem.summary       = %q{Rails mocks, presenters, exposure and scenarios}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "neo-rails"
  gem.require_paths = ["lib"]
  gem.version       = Neo::Rails::VERSION

  gem.add_dependency "view_model-rails"
  gem.add_dependency "mime-types", ['>= 1.0', '< 3.0']

  case rails_version
  when '3.2'
    gem.add_development_dependency "minitest", '~> 4.7'
  when /.*/
    gem.add_development_dependency "minitest"
  when NilClass
    abort "Missing env RAILS_VERSION"
  else
    abort "Rails version #{rails_version.inspect} not supported"
  end

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "simplecov"
end
