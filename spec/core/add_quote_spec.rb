require "minitest/autorun"
require_relative "../../core/add_author"
require_relative "../../core/add_user"
require_relative "../../core/add_quote"
require_relative "../../core/memory_db"

describe AddQuote do
  attr_reader :author_id, :db, :text, :user_id

  before(:each) do
    @db = InMemoryDB.new
    t = AddAuthor.new("John", @db)
    t.execute
    @author_id = t.author_id

    au = AddUser.new("Bill", "bill@example.com", db)
    au.execute
    @user_id = au.user_id
    @text = "lorem ipsum"
  end

  it "should add a quote for an author and attribute user" do
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    quote_id = aq.quote_id
    quote = db.get_quote(quote_id)

    author = db.get_author(author_id)
    author.quotes.first.text.must_equal text
    author.quotes.first.must_be_same_as quote
    user = db.get_user(user_id)
    author.quotes.first.must_be_same_as quote
    user.quotes.first.text.must_equal text
    author.quotes.first.must_be_same_as user.quotes.first
  end

  it "should add more quotes for an author" do
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    aq2 = AddQuote.new(user_id, author_id, text + "2", db)
    aq2.execute

    author = db.get_author(author_id)
    author.quotes.length.must_equal 2
    user = db.get_user(user_id)
    user.quotes.length.must_equal 2
  end

  it "should add quotes to correct user" do
    t = AddUser.new("John", "john@example.com", db)
    t.execute
    user2_id = t.user_id
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    aq2 = AddQuote.new(user2_id, author_id, text + "1", db)
    aq2.execute

    author = db.get_author(author_id)
    author.quotes.length.must_equal 2
    user = db.get_user(user_id)
    user.quotes.first.text.must_equal text
    user2 = db.get_user(user2_id)
    user2.quotes.first.text.must_equal text + "1"
  end

  it "should add author and user to quote" do
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    quote_id = aq.quote_id
    quote = db.get_quote(quote_id)

    quote.user.must_be_same_as db.get_user(user_id)
    quote.author.must_be_same_as db.get_author(author_id)
  end
end
