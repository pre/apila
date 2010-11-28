require 'rubygems'
require 'dm-core'
require 'app_config'
require 'dm-migrations'
require 'builder'

require 'sinatra' unless defined?(Sinatra)

configure do

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, AppConfig.database_url)

end
