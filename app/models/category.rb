class Category

  include DataMapper::Resource

  property :id, Serial
  property :title, String, :nullable => false

  has n, :pages, :through => Resource

end