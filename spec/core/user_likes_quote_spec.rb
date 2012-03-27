require "minitest/autorun"
require_relative "../../core/user_likes_quote"
require_relative "../../core/current_db"
require_relative "../../core/add_author"
require_relative "../../core/add_user"
require_relative "../../core/add_quote"

describe UserLikesQuote do
  it "should attribute a like to a user and a quote" do
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

    user.likes.length.must_equal 0
    quote.likes.length.must_equal 0

    lq = UserLikesQuote.new(user_id, quote_id, db)
    lq.execute

    user = db.get_user(user_id)
    quote = db.get_quote(quote_id)

    user.likes.length.must_equal 1
    quote.likes.length.must_equal 1

    lq = UserLikesQuote.new(user_id, quote_id, db)
    lq.execute

    user = db.get_user(user_id)
    quote = db.get_quote(quote_id)

    user.likes.length.must_equal 1
    quote.likes.length.must_equal 1

    user.likes.first.quote.must_equal quote
    quote.likes.first.user.must_equal user
  end
end
