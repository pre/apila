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
  "404 Not Found"
end

get '/' do
  "It works! Please request something."
end

get '/ringers/:id.xml' do
  build_xml_response(Ringer, :id => params[:id])
end

get '/municipalities/:id.xml' do
  build_xml_response(Municipality, :id => params[:id])
end

get '/municipalities.:format' do
  @municipalities = Municipality.filter_by_code(params[:code])

  case params['format'] when 'json'
    content_type :json
    @municipalities.to_json(:methods => :environment_centre)
  when 'xml'
    content_type :xml
    builder :municipalities
  else
    not_found
  end
end

get '/species.json' do
  content_type :json
  @species = Species.filter_by_code(params[:code])
  @species.to_json(:relationships => {:names => {}})
end

private

  def build_xml_response(object_class, query = {})
    instance_name = object_class.to_s.downcase
    instance_variable_set("@#{instance_name}", object_class.first(query))

    if instance_variable_get("@#{instance_name}")
      builder instance_name.to_sym
    else
      halt 404
    end
  end