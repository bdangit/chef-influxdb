require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'

task default: 'test:quick'

namespace :test do

  Rubocop::RakeTask.new

  Rake::TestTask.new do |t|
    t.name = :minitest
    t.test_files = Dir.glob('test/spec/**/*_spec.rb')
  end

  begin
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end

  desc 'Run all of the quick tests.'
  task :quick do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:minitest'].invoke
  end

  desc 'Run all tests, including test-kitchen.'
  task :complete do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:minitest'].invoke
    Rake::Task['test:kitchen:all'].invoke
  end
end
