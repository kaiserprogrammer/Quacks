require_relative "quacks"

describe Quacks do
  attr_reader :name, :quote
  before(:each) do
    Quacks.reset
  end

  before(:all) do
    @name = "author"
    @quote = "quote"
  end

  it "should get no quotes for an unknown author" do
    subject.quotes_for_author("beck").should == []
  end

  it "should get one quote for an author" do
    subject.save_quote(name, quote)
    subject.quotes_for_author(name).length.should == 1
  end

  it "should retrieve a previously saved quote" do
    subject.save_quote(name, quote)
    subject.quotes_for_author(name).first.should == quote
  end

  it "should retrieve all previously saved quotes" do
    quote2 = "quote2"
    subject.save_quote(name, quote)
    subject.save_quote(name, quote2)
    quotes = subject.quotes_for_author(name)
    quotes.first.should == quote
    quotes[1].should == quote2
  end

  it "should handle different quotes for different authors" do
    name2 = "author2"
    quote2 = "quote2"
    subject.save_quote(name, quote)
    subject.save_quote(name2, quote2)
    subject.quotes_for_author(name).first.should == quote
    subject.quotes_for_author(name2).first.should == quote2
  end

  it "should get all quotes for an author" do
    quote1 = "quote1"
    quote2 = "quote2"
    quote3 = "quote3"
    subject.save_quote(name, quote1)
    subject.save_quote(name, quote2)
    subject.save_quote(name, quote3)
    subject.quotes_for_author(name).length.should == 3
  end

  it "should only get quotes for a specific author" do
    unknown = "unknown"
    subject.save_quote(name, quote)
    subject.save_quote(unknown, unknown)
    subject.quotes_for_author(name).length.should == 1
  end

  it "should ignore duplicate quotes" do
    subject.save_quote(name, quote)
    subject.save_quote(name, quote)
    subject.quotes_for_author(name).length.should == 1
  end

  it "should store quotes" do
    subject.save_quote(name, quote)
    subject.all_quotes.length.should == 1
  end

  it "should retrieve all quotes" do
    name1 = "n1"
    quote1   = "q1"
    name2 = "n2"
    quote2   = "q2"
    name3 = "n3"
    quote3   = "q3"
    subject.save_quote(name1, quote1)
    subject.save_quote(name2, quote2)
    subject.save_quote(name3, quote3)
    subject.all_quotes.length.should == 3
  end

  it "should store an image file path for an author" do
    image_path = "path"
    subject.save_image(name, image_path)
    subject.image_path_of_author(name).should == image_path
  end

  it "change an image file path for an author" do
    old_image_path = "old_path"
    image_path = "path"
    subject.save_image(name, old_image_path)
    subject.image_path_of_author(name).should == old_image_path
    subject.save_image(name, image_path)
    subject.image_path_of_author(name).should == image_path
  end
end
