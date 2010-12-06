require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  def json_output(attribute, value)
    "\"#{attribute}\":#{value}"
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  describe 'XML builder' do
    specify 'should find object' do
      ringer_id = 10001
      ringer = Factory.build(:ringer, :id => ringer_id)
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
      ringer = Factory.build(:ringer, :id => ringer_id)
      Ringer.stub!(:first).and_return(ringer)
      get "/ringers/#{ringer_id}.xml"

      last_response.should be_ok
      last_response.body.should include("<ringer id=\"#{ringer_id}\">")
    end

    describe 'for municipalities' do
      specify 'should return municipality xml with environment centre' do
        municipality_id = 1
        municipality = Factory.build(:municipality, :id => municipality_id)
        Municipality.stub!(:first).and_return(municipality)
        get "/municipalities/#{municipality_id}.xml"

        last_response.should be_ok
        last_response.body.should include("<municipality id=\"#{municipality_id}\">")
        last_response.body.should include("<environment_centre id=\"#{municipality.environment_centre.id}\">")
      end

      specify 'should return a json array of all municipalities' do
        municipalities = []
        10.times do
          municipalities << Factory.build(:municipality)
        end
        Municipality.stub!(:all).and_return(municipalities)

        get "/municipalities.json"
        last_response.should be_ok
        municipalities.each do |municipality|
          last_response.body.should include(json_output("id", municipality.id))
        end
      end

      specify 'should return empty array when nothing is found' do
        Municipality.stub!(:filter_by_code).and_return(Array.new)
        get "/municipalities.json?code=UNMATCHED"
        last_response.should be_ok
        last_response.status.should == 200
      end

    end

    describe 'for species' do
      specify 'should return a json array of all species' do
        species = []
        1.times { species << Factory.build(:species) }
        Species.stub!(:filter_by_code).and_return(species)

        get "/species.json"
        last_response.should be_ok
        species.each do |s|
          last_response.body.should include(json_output("id", "\"#{s.id}\""))
        end
      end

      specify 'should return empty array when nothing is found' do
        Species.stub!(:filter_by_code).and_return(Array.new)
        get "/species.json?code=UNMATCHED"
        last_response.should be_ok
        last_response.status.should == 200
      end
    end
  end

end
