class Ringer
  include DataMapper::Resource
  storage_names[:default] = 'rengastaja'

  property :id,          Serial, :field => 'renro'
  property :email,       String, :field => 'reemail'
  property :first_name,  String, :field => 'reetunimi'
  property :last_name,   String, :field => 'resukunimi'

  def name
    self.first_name + " " + self.last_name
  end

  def self.shared_attributes
    @@shared_attributes ||= [:id, :email, :name]
  end

end