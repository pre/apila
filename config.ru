require 'application'

set :run, false

set :environment, ENV['RACK_ENV'].to_sym

FileUtils.mkdir_p AppConfig.log.directory unless File.exists?(AppConfig.log.directory)
log = File.new(File.join(AppConfig.log.directory, AppConfig.log.filename), "a+")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application
