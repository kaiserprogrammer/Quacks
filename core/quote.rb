class Quote
  attr_reader :text
  attr_accessor :id, :likes, :dislikes, :user, :author

  def initialize(text)
    @text = text
    @likes = []
    @dislikes = []
  end
end
