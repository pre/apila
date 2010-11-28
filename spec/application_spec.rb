require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  specify 'should return ringer xml' do
    ringer_id = 10000
    ringer = Factory.create(:ringer, :id => ringer_id)
    Ringer.should_receive(:first).with(:id => "#{ringer_id}").and_return(ringer)
    get "/ringers/#{ringer_id}.xml"

    last_response.should be_ok
    last_response.body.should include('<ringer id="10000">')
  end
  
  specify 'should return error code 404 when ringer is not found' do
    get '/ringers/99999999.xml'
    last_response.status.should == 404
  end
end
