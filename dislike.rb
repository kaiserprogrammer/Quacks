class Dislike
  attr_reader :user, :quote

  def initialize(user, quote)
    @user = user
    @quote = quote
  end
end
