class Page

  include DataMapper::Resource

  property :id, Serial
  property :title, String, :nullable => false
  property :body, Text, :nullable => false
  property :publish, Boolean, :default => false
  property :created_at, Date
  property :updated_at, Date

  has n, :categories, :through => Resource

end