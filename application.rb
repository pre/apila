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

get '/municipalities.xml' do
  municipalities = Municipality.filter_by_code(params[:code])

  if municipalities
    municipalities.to_xml(:methods => [:environment_centre], :only => Municipality.shared_attributes)
  else
    halt 404
  end
end

get '/species.xml' do
  species = Species.filter_by_code(params[:code])

  if species
    species.to_xml(:methods => [:names])
  else
    halt 404
  end
end
