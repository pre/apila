class Municipality
  include DataMapper::Resource
  storage_names[:default] = 'kunta'

  property :id,               Serial,  :field => 'kunro', :key => true
  property :code,             String,  :field => 'kulyh', :required => true
  property :name,             String,  :field => 'kunimi'
  property :latitude,         Float,   :field => 'kudeslev'
  property :longitude,        Float,   :field => 'kudespit'
  property :radius,           Integer, :field => 'kusade'

  property :environment_centre_id, Integer, :field => 'ku_ympkesk'

  belongs_to :environment_centre, :required => false

  def self.filter_by_code(code)
    if code.blank?
      all
    else
      all :code.like => "#{code.to_s.upcase}%"
    end
  end

  def self.shared_attributes
    @@shared_attributes ||= [:id, :code, :name, :latitude, :longitude, :radius]
  end

  def self.find_by_code(code)
    first :code => code.to_s.upcase
  end

end