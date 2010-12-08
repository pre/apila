require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  describe 'API XML responses' do

    specify 'should return 404 when requesting one entry which is not found' do
      ["/ringers/1.xml", "/municipalities/abc.xml"].each do |uri|
        get uri
        last_response.status.should be(404)
      end
    end

    specify 'should return ringer xml' do
      id = 10000
      ringer = Factory.build(:ringer, :id => id)
      Ringer.stub!(:first).and_return(ringer)

      get "/ringers/#{id}.xml"
      last_response.should be_ok
      last_response.body.should include("<email>#{ringer.email}</email>")
      last_response.body.should include("<name>#{ringer.name}</name>")
    end

    describe 'for municipalities' do
      specify 'should include environment centre in municipality xml' do
        xml_response = "<xml lol='cat'>"
        municipality = Factory.build(:municipality)
        municipality.should_receive(:to_xml).with(:methods => [:environment_centre],
                                                  :only => Municipality.shared_attributes).and_return(xml_response)
        Municipality.stub!(:first).and_return(municipality)

        get "/municipalities/#{municipality.code}.xml"
        last_response.body.should == xml_response
      end

      specify 'should produce an xml set of all municipalities' do
        xml_response = "lolcat"
        municipalities = mock(Object)
        municipalities.should_receive(:to_xml).and_return(xml_response)
        Municipality.should_receive(:filter_by_code).and_return(municipalities)

        get "/municipalities.xml"
        last_response.body.should == xml_response
      end

      specify 'should return code 200 when filtered resultset is empty' do
        get "/municipalities.xml?code=DOES_NOT_EXIST"
        last_response.status.should be(200)
      end

    end

    describe 'for species' do

      specify 'should produce an xml set of all species' do
        species = mock(DataMapper::Collection)
        species.should_receive(:to_xml)
        Species.should_receive(:filter_by_code).and_return(species)

        get "/species.xml"
        last_response.should be_ok
      end

      specify 'should include species name in the response' do
        finnish = Factory.build(:lexicon, :content => "Haikara")
        english = Factory.build(:lexicon, :content => "Stork", :language => "E")
        species = Factory.build(:species, :names => [finnish, english])
        Species.stub!(:filter_by_code).and_return(species)

        get "/species.xml"
        last_response.should be_ok
        last_response.body.should include("Haikara", "Stork")
      end

      specify 'should return code 200 when filtered resultset is empty' do
        get "/species.xml?code=DOES_NOT_EXIST"
        last_response.status.should be(200)
      end
    end
  end

end
