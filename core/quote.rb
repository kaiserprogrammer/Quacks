class Quote
  attr_reader :text, :user, :author
  attr_accessor :id, :likes, :dislikes

  def initialize(fields={})
    @text = fields[:text]
    @author = fields[:author]
    @user = fields[:user]
    @likes = []
    @dislikes = []
  end
end
