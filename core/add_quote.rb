require_relative "quote"

class AddQuote
  attr_reader :quote_id

  def initialize(user_id, author_id, quote, db)
    @user_id = user_id
    @author_id = author_id
    @quote = quote
    @db = db
    db.transactions.info("#{self.class},;,#{user_id},;,#{author_id},;,#{quote}")
  end

  def execute
    author = @db.get_author(@author_id)
    user = @db.get_user(@user_id)
    quote = Quote.new(@quote)
    @db.add_quote(quote)
    @quote_id = quote.id
    author.quotes << quote
    user.quotes << quote
  end
end