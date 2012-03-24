require "minitest/autorun"
require_relative "../../core/get_quotes"
require_relative "../../core/add_user"
require_relative "../../core/add_author"
require_relative "../../core/add_quote"
require_relative "../../core/memory_db"

describe GetQuotes do
  attr_reader :db

  before(:each) do
    @db = InMemoryDB.new
  end

  it "should get no quotes for an unknown author" do
    t = GetQuotes.new(0, @db)
    t.execute

    t.quotes.length.must_equal 0
  end

  it "should get one quote for an author" do
    t = AddAuthor.new("John", @db)
    t.execute
    author_id = t.author_id

    au = AddUser.new("Bill", "bill@example.com", @db)
    au.execute
    user_id = au.user_id

    text = "lorem ipsum"
    aq = AddQuote.new(user_id, author_id, text, @db)
    aq.execute

    gq = GetQuotes.new(author_id, @db)
    gq.execute
    gq.quotes.length.must_equal 1
    gq.quotes.first.text.must_equal text
  end
end
