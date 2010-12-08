require 'factory_girl'

Factory.sequence :email do |n|
  "rengastaja#{n}@example.com"
end

Factory.define :ringer do |f|
  f.first_name "Jouni"
  f.last_name "Kemppainen"
  f.email Factory.next(:email)
  f.sequence(:id) { |n| "#{n}" }
end

Factory.define :municipality do |f|
  f.code "AHLAIN"
  f.name "AHLAINEN"
  f.longitude 21.6666698
  f.latitude 61.6666718
  f.radius 20
  f.association :environment_centre

  f.sequence(:id) { |n| "#{n}" }
end

Factory.define :environment_centre do |f|
  f.sequence(:name) { |n| "Yleismaailmallinen ymparistokeskus nro #{n}" }
  f.sequence(:id) { |n| "#{n}" }
end

Factory.define :species do |f|
  f.sequence(:id) { |n| "#{n}"}
  f.sequence(:code) { |n| "GAVS#{n}"}

  f.names { |names| [names.association(:lexicon)] }
end

Factory.define :lexicon do |f|
  f.sequence(:content) { |n| "Harmaahaikara #{n}" }
  f.sequence(:code) { |n| n }
  f.category 8
  f.language "S"
end