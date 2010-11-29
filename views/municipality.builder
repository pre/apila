xml.instruct!
xml.municipality :id => @municipality.id do
  xml.code @municipality.code
  xml.name @municipality.name
  xml.latitude @municipality.latitude
  xml.longitude @municipality.longitude
  xml.radius @municipality.radius
end