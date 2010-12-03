class Species
  include DataMapper::Resource
  storage_names[:default] = 'laji'

  property :id,               String,  :field => 'lanro', :key => true
  property :code,             String,   :field => 'lalyh', :required => true

  has n, :names, 'Lexicon', :parent_key => [:id], :child_key => [:code]

end