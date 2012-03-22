class User
  attr_reader :name, :email
  attr_accessor :id, :quotes

  def initialize(name, email)
    @name = name
    @email = email
    @quotes = []
  end
end
