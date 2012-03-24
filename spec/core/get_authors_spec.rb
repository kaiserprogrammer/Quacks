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

    ga2 = GetAuthors.new(db)
    ga2.execute
    ga2.authors.length.must_equal 1
  end
end
