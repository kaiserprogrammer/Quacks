require_relative "author_methods"

class Author
  include AuthorMethods
  attr_reader :name
  attr_accessor :id, :quotes, :image

  def initialize(fields={})
    @name = fields[:name]
    @quotes = []
  end
end
