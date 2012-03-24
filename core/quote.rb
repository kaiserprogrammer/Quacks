class Quote
  attr_reader :text
  attr_accessor :id, :likes, :dislikes

  def initialize(text)
    @text = text
    @likes = []
    @dislikes = []
  end
end
