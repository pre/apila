require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Ringer' do
  before(:each) do
    @ringer = Ringer.new(:id => "10000", :first_name => 'Pekka', :last_name => 'Sormisuu', :email => "test@addr.fi")
  end
  
  specify 'should have a name composed of first and last name' do
    @ringer.name.should == "Pekka Sormisuu"
  end
  
end
