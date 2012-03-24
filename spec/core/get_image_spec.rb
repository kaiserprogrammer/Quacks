require "minitest/autorun"
require_relative "../../core/get_image"
require_relative "memory_db"
require_relative "../../core/add_author"
require_relative "../../core/add_image"

describe GetImage do
  it "should get an image for an author" do
    db = InMemoryDB.new
    t = AddAuthor.new("Jimmy", db)
    t.execute
    author_id = t.author_id

    image_url = "http://this.de/that.png"
    ai = AddImage.new(author_id, image_url, db)
    ai.execute

    gi = GetImage.new(author_id, db)
    gi.execute
    gi.url.must_equal image_url
  end
end
