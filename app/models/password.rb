class Password

  include DataMapper::Resource
  include DataMapper::Validate

  attr_accessor :password, :password_confirmation

  property :id, Integer, :key => true, :serial => true
  property :encrypted, String

  validates_present(:password, :password_confirmation)
  validates_length(:password, :within => 4..20)
  validates_is_confirmed(:password, :groups => :create)

  before :save, :encrypt

  protected

  require "digest/sha1"

  def encrypt
    attribute_set(:encrypted, Digest::SHA1.hexdigest("--#{password}--"))
  end

end