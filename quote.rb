class Quote
  attr_reader :quote
  attr_accessor :id, :likes, :dislikes

  def initialize(quote)
    @quote = quote
    @likes = []
    @dislikes = []
  end
end
