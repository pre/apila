xml.instruct!

xml.municipalities do

  @municipalities.each do |@municipality|
    xml.municipality :id => @municipality.id do
      xml.code @municipality.code
      xml.name @municipality.name
      xml.latitude @municipality.latitude
      xml.longitude @municipality.longitude
      xml.radius @municipality.radius

      if @municipality.environment_centre
        xml.environment_centre :id => @municipality.environment_centre.id do
          xml.name @municipality.environment_centre.name
        end
      end
    end

  end

end
