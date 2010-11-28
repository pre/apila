require 'factory_girl'

Factory.sequence :email do |n|
  "rengastaja#{n}@example.com"
end

Factory.define :ringer do |r|
  r.first_name "Jouni"
  r.last_name "Kemppainen"
  r.sequence(:email) { |n| "jouni#{n}@example#{n}.com" }
  r.sequence(:id) { |n| "#{n}" }  
end
