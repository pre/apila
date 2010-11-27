require 'rubygems'
require 'dm-core'
require 'app_config'

require 'sinatra' unless defined?(Sinatra)

configure do

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, AppConfig.database_url)

  # Test environment's config
  configure :test do
    DataMapper.setup(:default, "sqlite::memory:")
  end
  
end
