#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end
