class Species
  include DataMapper::Resource
  storage_names[:default] = 'laji'

  property :id,               String,   :field => 'lanro', :key => true
  property :code,             String,   :field => 'lalyh', :required => true

  has n, :names, 'Lexicon', :parent_key => :id, :child_key => :code, :category => 8

  def self.filter_by_code(code)
    all :code.like => "#{code.to_s.upcase}%"
  end

  def self.filter_by_lang(lang_code)
    all Species.names.language => lang_code
  end
end