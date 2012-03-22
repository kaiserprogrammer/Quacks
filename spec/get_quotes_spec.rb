require "minitest/autorun"
require_relative "../get_quotes"
require_relative "../add_author"
require_relative "../add_quote"
require_relative "memory_db"

describe GetQuotes do
  attr_reader :db

  before(:each) do
    @db = InMemoryDB.new
  end

  it "should get no quotes for an unknown author" do
    t = GetQuotes.new(0, @db)
    t.execute

    t.quotes.must_equal []
  end

  it "should get one quote for an author" do
    t = AddAuthor.new("John", @db)
    t.execute
    id = t.author_id

    text = "lorem ipsum"
    aq = AddQuote.new(id, text, @db)
    aq.execute

    gq = GetQuotes.new(id, @db)
    gq.execute
    gq.quotes.length.must_equal 1
    gq.quotes.first.must_equal text
  end
end
