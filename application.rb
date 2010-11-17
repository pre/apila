require 'rubygems'
require 'sinatra'
require 'environment'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
end

get '/' do
  #haml :root
  "Toimii!"
end

get '/ringers/:id.xml' do
  @ringer = Ringer.first(:id => params["id"])
  if @ringer
    builder :ringer
  else 
    halt 404
  end
end
