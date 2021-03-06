require "minitest/autorun"
require_relative "../../core/user_dislikes_quote"
require_relative "../../core/current_db"
require_relative "../../core/add_quote"
require_relative "../../core/add_user"
require_relative "../../core/add_author"

describe UserDislikesQuote do
  it "should attribute a dislike to a user and a quote" do
    DB.auto_migrate!
    db = DB.new
    t = AddAuthor.new("Bim", db)
    t.execute
    author_id = t.author_id

    au = AddUser.new("Jimmy", "jimy@example.com", db)
    au.execute
    user_id = au.user_id

    aq = AddQuote.new(user_id, author_id, "blub", db)
    aq.execute

    user = db.get_user(user_id)
    quote_id = user.quotes.first.id
    quote = db.get_quote(quote_id)

    user.dislikes.length.must_equal 0
    quote.dislikes.length.must_equal 0

    lq = UserDislikesQuote.new(user_id, quote_id, db)
    lq.execute

    lq = UserDislikesQuote.new(user_id, quote_id, db)
    lq.execute

    user = db.get_user(user_id)
    quote = db.get_quote(quote_id)
    user.dislikes.length.must_equal 1
    quote.dislikes.length.must_equal 1
    user.dislikes.first.quote.must_equal quote
    quote.dislikes.first.user.must_equal user
  end
end
