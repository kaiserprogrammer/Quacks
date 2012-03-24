require "minitest/autorun"
require_relative "../../core/get_authors"
require_relative "../../core/add_author"
require_relative "../../core/memory_db"

describe GetAuthors do
  it "should retrieve all authors" do
    db = InMemoryDB.new

    ga = GetAuthors.new(db)
    ga.execute
    ga.authors.length.must_equal 0

    t = AddAuthor.new("Bill", db)
    t.execute
    author = db.get_author(t.author_id)

    ga.execute
    ga.authors.first.must_equal author
    ga.authors.length.must_equal 1

    t2 = AddAuthor.new("Bonny", db)
    t2.execute

    ga.execute
    ga.authors.length.must_equal 2
  end
end
