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

not_found do
  content_type :text
  "404 Not Found"
end

before do
  content_type :xml
end

get '/' do
  "It works! Please request something."
end

get '/ringers/:id.xml' do
  ringer = Ringer.first(:id => params[:id])

  if ringer
    ringer.to_xml(:methods => [:name], :only => Ringer.shared_attributes)
  else
    halt 404
  end
end

get '/municipalities/:id.xml' do
  municipality = Municipality.first(:id => params[:id])

  if municipality
    municipality.to_xml(:methods => [:environment_centre], :only => Municipality.shared_attributes)
  else
    halt 404
  end
end

get '/municipalities.:format' do
  @municipalities = Municipality.filter_by_code(params[:code])

  case params['format'] when 'json'
    content_type :json
    @municipalities.to_json(:methods => :environment_centre)
  when 'xml'
    content_type :xml
    @municipalities.to_xml(:methods => [:environment_centre], :only => Municipality.shared_attributes)
  else
    not_found
  end
end

get '/species.json' do
  content_type :json
  @species = Species.filter_by_code(params[:code])
  @species.to_json(:relationships => {:names => {}})
end
