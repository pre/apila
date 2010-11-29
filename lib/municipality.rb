class Municipality
  include DataMapper::Resource
  storage_names[:default] = 'kunta'

  property :id,               Serial,  :field => 'kunro'
  property :code,             String,  :field => 'kulyh', :required => true
  property :name,             String,  :field => 'kunimi'
  property :latitude,      Float,   :field => 'kudeslev'
  property :longitude,     Float,   :field => 'kudespit'
  property :radius,           Integer, :field => 'kusade'

end