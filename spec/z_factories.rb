require 'factory_girl'

Factory.sequence :email do |n|
  "rengastaja#{n}@example.com"
end

Factory.define :ringer do |f|
  f.first_name "Jouni"
  f.last_name "Kemppainen"
  f.sequence(:email) { |n| "jouni#{n}@example#{n}.com" }
  f.sequence(:id) { |n| "#{n}" }
end

Factory.define :municipality do |f|
  f.code "AHLAIN"
  f.name "AHLAINEN"
  f.longitude 21.6666698
  f.latitude 61.6666718
  f.radius 20

  f.sequence(:id) { |n| "#{n}" }
end
