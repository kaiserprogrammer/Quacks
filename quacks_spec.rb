require "minitest/autorun"
require_relative "quacks"

class InMemoryDB
  attr_reader :quotes, :images

  def initialize
    @quotes = Hash.new {|h, k| h[k] = [] }
    @images = {}
  end
end

describe Quacks do
  attr_reader :name, :quote, :db

  before(:each) do
    @db = InMemoryDB.new
  end

  subject do
    Quacks
  end

  before do
    @name = "author"
    @quote = "quote"
  end

  it "should get no quotes for an unknown author" do
    subject.quotes_for_author("beck", db).must_equal []
  end

  it "should get one quote for an author" do
    subject.save_quote(name, quote, db)
    subject.quotes_for_author(name, db).length.must_equal 1
  end

  it "should retrieve a previously saved quote" do
    subject.save_quote(name, quote, db)
    subject.quotes_for_author(name, db).first.must_equal quote
  end

  it "should handle different quotes for different authors" do
    name2 = "author2"
    quote2 = "quote2"
    subject.save_quote(name, quote, db)
    subject.save_quote(name2, quote2, db)
    subject.quotes_for_author(name, db).first.must_equal quote
    subject.quotes_for_author(name2, db).first.must_equal quote2
  end

  it "should get all quotes for an author" do
    quote1 = "quote1"
    quote2 = "quote2"
    quote3 = "quote3"
    subject.save_quote(name, quote1, db)
    subject.save_quote(name, quote2, db)
    subject.save_quote(name, quote3, db)
    subject.quotes_for_author(name, db).length.must_equal 3
  end

  it "should only get quotes for a specific author" do
    unknown = "unknown"
    subject.save_quote(name, quote, db)
    subject.save_quote(unknown, unknown, db)
    subject.quotes_for_author(name, db).length.must_equal 1
  end

  it "should ignore duplicate quotes" do
    subject.save_quote(name, quote, db)
    subject.save_quote(name, quote, db)
    subject.quotes_for_author(name, db).length.must_equal 1
  end

  it "should store quotes" do
    subject.save_quote(name, quote, db)
    subject.all_quotes(db).length.must_equal 1
  end

  it "should store an image file path for an author" do
    image_path = "path"
    subject.save_image(name, image_path, db)
    subject.image_path_of_author(name, db).must_equal image_path
  end

end
