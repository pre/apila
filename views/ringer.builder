xml.instruct!
xml.ringer :id => @ringer.id do
  xml.name @ringer.friendly_name
  xml.email @ringer.email
end