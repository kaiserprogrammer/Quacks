require "minitest/autorun"
require_relative "../../core/add_author"
require_relative "memory_db"

describe AddAuthor do
  it "should create an author" do
    name = "John"
    db = InMemoryDB.new
    t = AddAuthor.new(name, db)
    t.execute
    id = t.author_id

    author = db.get_author(id)
    author.name.must_equal name
  end

  it "should deliver an existing author" do
    name = "John"
    db = InMemoryDB.new
    t = AddAuthor.new(name, db)
    t.execute
    id = t.author_id

    author = db.get_author(id)
    author.name.must_equal name

    t2 = AddAuthor.new(name, db)
    t2.execute
    id2 = t2.author_id

    author2 = db.get_author(id2)
    author2.name.must_equal name
    author2.must_be_same_as author
  end
end
