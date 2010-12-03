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
  #haml :root
  "Toimii!"
end

get '/ringers/:id.xml' do
  build_xml_response(Ringer, params[:id])
end

get '/municipalities/:id.xml' do
  build_xml_response(Municipality, params[:id])
end


private

  def build_xml_response(object_class, id)
    instance_name = object_class.to_s.downcase
    instance_variable_set("@#{instance_name}", object_class.first(:id => id))

    if instance_variable_get("@#{instance_name}")
      builder instance_name.to_sym
    else
      halt 404
    end
  end