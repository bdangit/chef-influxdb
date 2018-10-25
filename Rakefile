require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'foodcritic'

task default: 'test:quick'

def version
  File.read('metadata.rb')[/^version\s*'(\d.\d.\d)'/, 1]
end

desc 'Bump the version'
task :bump do
  bump_level = ENV['BUMPLEVEL'] || 'patch'
  sh "bump #{bump_level} --no-bundle --no-commit"
end

desc 'Update Changelog'
task :changelog do
  sh "github_changelog_generator --future-release #{version}"
end

desc 'Tag the release'
task :tag do
  sh "github-release release -u bdangit -r chef-influxdb --tag #{version}"
end

desc 'Print version of cookbook'
task :version do
  puts version
end

desc 'Publish cookbook into Supermarket'
task :publish do
  sh "cd ..; knife supermarket share influxdb 'Monitoring & Trending' -o ."
end

# rubocop:disable Metrics/BlockLength
namespace :test do
  RuboCop::RakeTask.new

  Rake::TestTask.new do |t|
    t.name = :minitest
    t.test_files = Dir.glob('test/spec/**/*_spec.rb')
  end

  FoodCritic::Rake::LintTask.new do |t|
    t.name = :foodcritic
    t.options = {
      tags: ['~FC016', '~FC121'],
      fail_tags: ['any']
    }
  end

  begin
    require 'kitchen'
    namespace :integration do
      desc 'Run Test Kitchen with Vagrant'
      task :vagrant do
        Kitchen.logger = Kitchen.default_file_logger
        Kitchen::Config.new.instances.each do |instance|
          instance.test(:always)
        end
      end
    end
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end

  desc 'Run all of the quick tests.'
  task :quick do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:minitest'].invoke
    Rake::Task['test:foodcritic'].invoke
  end

  desc 'Run all tests, including test-kitchen.'
  task :complete do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:minitest'].invoke
    Rake::Task['test:foodcritic'].invoke
    Rake::Task['test:integration:vagrant'].invoke
  end
end
# rubocop:enable Metrics/BlockLength
