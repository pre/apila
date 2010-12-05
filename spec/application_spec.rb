require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  def json_output(attribute, value)
    "\"#{attribute}\":\"#{value}\""
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  describe 'XML builder' do
    specify 'should find object' do
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

    describe 'for municipalities' do
      specify 'should return municipality xml with environment centre' do
        municipality_id = 1
        municipality = Factory.create(:municipality, :id => municipality_id)
        get "/municipalities/#{municipality_id}.xml"

        last_response.should be_ok
        last_response.body.should include("<municipality id=\"#{municipality_id}\">")
        last_response.body.should include("<environment_centre id=\"#{municipality.environment_centre.id}\">")
      end

      specify 'should return a json array of all municipalities' do
        municipalities = []
        10.times do
          municipalities << Factory.create(:municipality)
        end

        get "/municipalities.json"
        last_response.should be_ok
        municipalities.each do |municipality|
          last_response.body.should include('"id":'+ municipality.id.to_s)
        end
      end

      specify 'should return a filtered json array of municipalities' do
        query = "AABB"
        should_match = []

        ["#{query}AA", query, "#{query}CC", "#{query}1"].each do |matched_code|
          should_match << Factory.create(:municipality, :code => matched_code)
        end

        get "/municipalities.json?code=#{query}"
        last_response.should be_ok
        should_match.each do |m|
          last_response.body.should include(json_output("code", m.code))
        end
      end

      specify 'should return only the requested municipalities' do
        query = "AABB"
        should_not_match = []
        should_match = Factory.create(:municipality, :code => "#{query}AWER")

        ["AABC", "A#{query}", "CC", "AA"].each do |unmatched_code|
          should_not_match << Factory.create(:municipality, :code => unmatched_code)
        end

        get "/municipalities.json?code=#{query}"
        last_response.should be_ok
        last_response.body.should include(json_output("code", should_match.code))

        should_not_match.each do |m|
          last_response.body.should_not include(json_output("code", m.code))
        end
      end

    end

  end

end
