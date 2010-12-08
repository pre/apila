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
  respond_with(Ringer.first(:id => params[:id]), { :methods => [:name], 
                                                   :only => Ringer.shared_attributes })
end

get '/municipalities/:code.xml' do
  respond_with(Municipality.find_by_code(params[:code]), { :methods => [:environment_centre], 
                                                           :only => Municipality.shared_attributes })
end

get '/municipalities.xml' do
  municipalities = Municipality.filter_by_code(params[:code])
  municipalities.to_xml(:methods => [:environment_centre], :only => Municipality.shared_attributes)
end

get '/species.xml' do
  species = Species.filter_by_code(params[:code])
  species.to_xml(:methods => [:names])
end

private
  def respond_with(object, opts = {})
    if object
      object.to_xml(opts)
    else
      halt 404
    end
  end