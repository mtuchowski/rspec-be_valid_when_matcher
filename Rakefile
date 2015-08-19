require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'

RSpec::Core::RakeTask.new('spec') do |task|
  task.rspec_opts    = '--options config/config.rspec'
  task.fail_on_error = false
end

namespace :lint do
  RuboCop::RakeTask.new('style') do |task|
    task.options       = ['-c', 'config/rubocop.yml']
    task.fail_on_error = true
  end

  Reek::Rake::Task.new('maintainability') do |task|
    task.config_file   = 'config/reek.yml'
    task.source_files  = 'lib/**/*.rb'
    task.fail_on_error = true
  end

  desc 'Check markdown files style'
  task :docs do
    system 'mdl . -gws config/config.mdl'
  end
end

desc 'Run all linters'
task :lint do
  Rake::Task['lint:style'].invoke
  puts 'Running Reek...'
  Rake::Task['lint:maintainability'].invoke
  puts 'Running mdl...'
  Rake::Task['lint:docs'].invoke
end

desc 'delete generated files'
task :clobber do
  sh 'rm -rf .yardoc'
  sh 'rm -rf doc'
end

desc 'generate rdoc'
task :rdoc do
  sh 'yardoc'
end
