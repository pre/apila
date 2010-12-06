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

get '/municipalities.json' do
  content_type :json
  @municipalities = Municipality.filter_by_code(params[:code])
  @municipalities.to_json(:methods => :environment_centre)
end

get '/species.json' do
  content_type :json
  @species = Species.filter_by_code(params[:code])
  @species = @species.filter_by_lang(params[:lang]) if params[:lang]
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