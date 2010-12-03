xml.instruct!
xml.municipality :id => @municipality.id do
  xml.code @municipality.code
  xml.name @municipality.name
  xml.latitude @municipality.latitude
  xml.longitude @municipality.longitude
  xml.radius @municipality.radius

  xml.environment_centre :id => @municipality.environment_centre.id do
    xml.name @municipality.environment_centre.name
  end
end