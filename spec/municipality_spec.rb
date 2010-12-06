require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Municipality' do

  specify 'should return a filtered array of municipalities' do
    code = "AABB"
    valid = []

    ["#{code}AA", code, "#{code}CC", "#{code}1"].each do |matched_code|
      valid << Factory.create(:municipality, :code => matched_code)
    end

    matched = Municipality.filter_by_code(code)
    valid.each do |m|
      matched.should include(m)
    end
  end

  specify 'should return only the requested municipalities' do
    code = "AABB"
    invalid = []
    valid = Factory.create(:municipality, :code => "#{code}AWER")

    ["AABC", "A#{code}", "CC", "AA"].each do |unmatched_code|
      invalid << Factory.create(:municipality, :code => unmatched_code)
    end

    matched = Municipality.filter_by_code(code)
    matched.should include(valid)

    invalid.each do |m|
      matched.should_not include(m)
    end
  end

end