require_relative "like"

class UserLikesQuote
  def initialize(user_id, quote_id, db)
    @user_id = user_id
    @quote_id = quote_id
    @db = db
    db.transactions.info("#{self.class},;,#{user_id},;,#{quote_id}")
  end

  def execute
    user = @db.get_user(@user_id)
    quote = @db.get_quote(@quote_id)
    like = Like.new(user, quote)
    user.likes << like
    quote.likes << like
  end
end
