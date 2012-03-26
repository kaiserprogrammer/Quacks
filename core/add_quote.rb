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
    if user == :user_does_not_exist
      raise "Quacks#user_does_not_exist"
    elsif author == :author_does_not_exist
      raise "Quacks#author_does_not_exist"
    else
      quote = Quote.new(@quote)
      quote.user = user
      quote.author = author
      @db.add_quote(quote)
      @quote_id = quote.id
      author.quotes << quote
      user.quotes << quote
    end
  end
end
