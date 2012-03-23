require_relative "dislike"

class UserDislikesQuote
  def initialize(user_id, quote_id, db)
    @user_id = user_id
    @quote_id = quote_id
    @db = db
  end

  def execute
    user = @db.get_user(@user_id)
    quote = @db.get_quote(@quote_id)
    dislike = Dislike.new(user, quote)
    user.dislikes << dislike
    quote.dislikes << dislike
  end
end
