class Author
  attr_reader :name
  attr_accessor :id, :quotes, :image

  def initialize(fields={})
    @name = fields[:name]
    @quotes = []
  end
end
