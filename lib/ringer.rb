class Ringer
  include DataMapper::Resource
  storage_names[:default] = 'rengastaja'

  property :id,          Serial, :field => 'renro'
  property :email,       String, :field => 'reemail'
  property :first_name,  String, :field => 'reetunimi'
  property :last_name,   String, :field => 'resukunimi'

  def friendly_name
    self.first_name + " " + self.last_name
  end
  
end