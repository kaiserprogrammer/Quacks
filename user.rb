class User
  attr_reader :name, :email
  attr_accessor :id

  def initialize(name, email)
    @name = name
    @email = email
  end
end
