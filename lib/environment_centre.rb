class EnvironmentCentre
  include DataMapper::Resource
  storage_names[:default] = 'ympkesk'

  property :id,               Serial,  :field => 'ympk_numero', :required => true
  property :name,             String,  :field => 'ympk_nimi',   :required => true

  has n, :municipalities
end