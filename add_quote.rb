require_relative "quote"

class AddQuote
  def initialize(user_id, author_id, quote, db)
    @user_id = user_id
    @author_id = author_id
    @quote = quote
    @db = db
  end

  def execute
    author = @db.get_author(@author_id)
    user = @db.get_user(@user_id)
    quote = Quote.new(@quote)
    author.quotes << quote
    user.quotes << quote
  end
end
