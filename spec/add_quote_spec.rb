require "minitest/autorun"
require_relative "../add_author"
require_relative "../add_quote"
require_relative "memory_db"

describe AddQuote do
  it "should add a quote for an author" do
    db = InMemoryDB.new
    t = AddAuthor.new("John", db)
    t.execute
    id = t.author_id

    text = "lorem ipsum"
    aq = AddQuote.new(id, text, db)
    aq.execute

    author = db.get_author(id)
    author.quotes.first.must_equal text
  end

  it "should add more quotes for an author" do
    db = InMemoryDB.new
    t = AddAuthor.new("Bill", db)
    t.execute
    id = t.author_id

    text = "lorem ipsum"
    aq = AddQuote.new(id, text, db)
    aq.execute
    aq2 = AddQuote.new(id, text + "2", db)
    aq2.execute

    author = db.get_author(id)
    author.quotes.length.must_equal 2
  end
end
