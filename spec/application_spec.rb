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
      last_response.status.should == 200
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
      id = 10000
      email = "testeri@yksityinen.osoite.example.com"
      ringer = Factory.build(:ringer, :id => id, :email => email)
      Ringer.stub!(:first).and_return(ringer)

      get "/ringers/#{id}.xml"
      last_response.should be_ok
      last_response.body.should include("<email>#{email}</email>")
      last_response.body.should include("<name>#{ringer.name}</name>")
    end

    describe 'for municipalities' do
      specify 'should return municipality xml with environment centre' do
        municipality_id = 1
        municipality = Factory.build(:municipality, :id => municipality_id)
        Municipality.stub!(:first).and_return(municipality)

        get "/municipalities/#{municipality_id}.xml"
        last_response.should be_ok
        last_response.body.should include("<name>#{municipality.name}</name>")
        last_response.body.should include("<name>#{municipality.environment_centre.name}")
      end

      specify 'should return an xml array of all municipalities' do
        municipalities = []
        10.times { |n| municipalities << Factory.create(:municipality, :code => "Municipality no #{n}") }
        ## FIXME: Sholuld stub, but don't know how to get DataMapper objects who have #to_xml (replace .create with .build)
        # Municipality.stub!(:all).and_return(municipalities)

        get "/municipalities.xml"
        last_response.should be_ok
        municipalities.each do |municipality|
          last_response.body.should include("<code>#{municipality.code}</code>")
        end
      end

      specify 'should return 404 for municipalities with unknown format' do
        get "/municipalities.xyz"
        last_response.status.should be(404)
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

      specify 'should include species name in the response' do
        finnish = Factory.build(:lexicon, :content => "Haikara")
        english = Factory.build(:lexicon, :content => "Stork", :language => "E")
        species = Factory.build(:species, :names => [finnish, english])
        Species.stub!(:filter_by_code).and_return(species)

        get "/species.json"
        last_response.should be_ok
        last_response.body.should include("Haikara", "Stork")
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
