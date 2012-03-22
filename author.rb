class Author
  attr_reader :name
  attr_accessor :id, :quotes

  def initialize(name)
    @name = name
    @quotes = []
  end
end
