require_relative "dislike"

class UserDislikesQuote
  def initialize(user_id, quote_id, db)
    @user_id = user_id
    @quote_id = quote_id
    @db = db
  end

  def execute
    user = @db.get_user(@user_id)
    disliked_already = user.dislikes.any? do |dislike|
      dislike.quote.id == @quote_id
    end
    unless disliked_already
      quote = @db.get_quote(@quote_id)
      dislike = Dislike.new(user, quote)
      user.dislikes << dislike
      quote.dislikes << dislike
    end
  end
end
