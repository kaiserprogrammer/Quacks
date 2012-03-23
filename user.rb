class User
  attr_reader :name, :email
  attr_accessor :id, :quotes, :likes, :dislikes

  def initialize(name, email)
    @name = name
    @email = email
    @quotes = []
    @likes = []
    @dislikes = []
  end
end
