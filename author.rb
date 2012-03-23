class Author
  attr_reader :name
  attr_accessor :id, :quotes, :image

  def initialize(name)
    @name = name
    @quotes = []
  end
end
