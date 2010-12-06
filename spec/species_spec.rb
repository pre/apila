require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Species' do
  before(:each) do
  end

  specify 'should have translated names' do
    species = Factory.create(:species)
    species.names.first(:language => 'S').should_not be_blank
  end

  specify 'should return a filtered array of species' do
    code = "GAVS"
    valid = []

    ["#{code}AA", code, "#{code}CC", "#{code}1"].each do |matched_code|
      valid << Factory.create(:species, :code => matched_code)
    end

    matched = Species.filter_by_code(code)
    valid.each do |m|
      matched.should include(m)
    end
  end

  specify 'should return only the requested municipalities' do
    code = "GAVS"
    invalid = []
    valid = Factory.create(:species, :code => "#{code}A")

    ["AABC", "A#{code}", "CC", "AA"].each do |unmatched_code|
      invalid << Factory.create(:species, :code => unmatched_code)
    end

    matched = Species.filter_by_code(code)
    matched.should include(valid)

    invalid.each do |m|
      matched.should_not include(m)
    end
  end
end
