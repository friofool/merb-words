class Order

  include DataMapper::Resource

  property :id, Serial
  property :property, String
  property :title, String

end