require_relative "user_methods"

class User
  include UserMethods

  attr_reader :name, :email
  attr_accessor :id, :quotes, :likes, :dislikes

  def initialize(fields={})
    @name = fields[:name]
    @email = fields[:email]
    @quotes = []
    @likes = []
    @dislikes = []
  end
end
