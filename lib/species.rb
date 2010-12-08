class Species
  include DataMapper::Resource
  storage_names[:default] = 'laji'

  property :id,               String,   :field => 'lanro', :key => true
  property :code,             String,   :field => 'lalyh', :required => true

  has n, :names, 'Lexicon', :parent_key => :id, :child_key => :code, :category => 8

  def self.filter_by_code(code)
    if code.blank?
      all
    else
      all :code.like => "#{code.to_s.upcase}%"
    end
  end

  def self.shared_attributes
    @@shared_attributes ||= [:id, :code]
  end

end