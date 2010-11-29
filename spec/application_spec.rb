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

  describe 'xml builder' do
    specify 'xml builder should find object' do
      ringer_id = 10001
      ringer = Factory.create(:ringer, :id => ringer_id)
      Ringer.should_receive(:first).with(:id => "#{ringer_id}").and_return(ringer)
      get "/ringers/#{ringer_id}.xml"
    end

    specify 'should return error code 404 when object is not found' do
      ringer_id = 9999999
      Ringer.should_receive(:first).with(:id => "#{ringer_id}").and_return(nil)
      get "/ringers/#{ringer_id}.xml"
      last_response.status.should == 404
    end

  end
  
  describe 'API XML responses' do
    specify 'should return ringer xml' do
      ringer_id = 10000
      ringer = Factory.create(:ringer, :id => ringer_id)
      get "/ringers/#{ringer_id}.xml"

      last_response.should be_ok
      last_response.body.should include("<ringer id=\"#{ringer_id}\">")
    end

    specify 'should return municipality xml' do
      municipality_id = "1"
      municipality = Factory.create(:municipality, :id => municipality_id)
      get "/municipalities/#{municipality_id}.xml"
    
      last_response.should be_ok
      last_response.body.should include("<municipality id=\"#{municipality_id}\">")
    end
    
  end
  
end
