require 'spec/rake/spectask'

task :default => :test
task :test => :spec

if !defined?(Spec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate => :environment do
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end
end

namespace :gems do
  desc 'Install Gems with Bundler'
  task :install do
    system "bundle install"
  end

  desc 'Update Gems with Bundler'
  task :update do
    system "bundle update"
  end

  desc 'Inspect the bundle to see whether applications requirements are met'
  task :check do
    system "bundle check"
  end

  desc 'List all Gems in the bundle'
  task :list do
    system "bundle list"
  end

end

task :environment do
  require 'environment'
end
