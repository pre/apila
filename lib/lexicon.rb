class Lexicon
  include DataMapper::Resource
  storage_names[:default] = 'sanasto'

  property :category,         Integer, :field => 'satunnus',  :required => true, :key => true
  property :language,         String,  :field => 'sakieli',   :required => true, :key => true
  property :code,             String,  :field => 'sakoodi',                      :key => true
  property :abbreviation,     String,  :field => 'salyh'
  property :content,          String,  :field => 'sateksti'

  has n, :species, :parent_key => :code, :child_key => :id
end
