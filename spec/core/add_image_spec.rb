require "minitest/autorun"
require_relative "../../core/add_image"
require_relative "memory_db"
require_relative "../../core/add_author"

describe AddImage do
  it "should add an image for an author" do
    db = InMemoryDB.new
    t = AddAuthor.new("Billy", db)
    t.execute
    author_id = t.author_id
    image_path = "http://blub.com/this.jpeg"

    ai = AddImage.new(author_id, image_path, db)
    ai.execute

    author = db.get_author(author_id)
    author.image.src.must_equal image_path
  end

  it "should change an existing image for an author" do
    db = InMemoryDB.new
    t = AddAuthor.new("Billy", db)
    t.execute
    author_id = t.author_id
    image_path = "http://blub.com/this.jpeg"

    ai = AddImage.new(author_id, image_path, db)
    ai.execute
    ai2 = AddImage.new(author_id, image_path + "2", db)
    ai2.execute

    author = db.get_author(author_id)
    author.image.src.must_equal image_path + "2"
  end
end
