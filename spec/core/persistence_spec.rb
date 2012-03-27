require "minitest/autorun"
require_relative "../../core/current_db"
require_relative "../../core/add_user"
require_relative "../../core/add_author"
require_relative "../../core/add_quote"
require_relative "../../core/add_image"
require_relative "../../core/user_likes_quote"
require_relative "../../core/user_dislikes_quote"

if DB.persistent?
describe DB do
  before(:each) do
    DB.auto_migrate!
  end

  it "should be no data in database" do
    db = DB.new
    new_db = DB.new
    new_db.get_all_users.must_equal []
    new_db.get_all_authors.must_equal []
    new_db.get_user(1).must_equal :user_does_not_exist
    new_db.get_user_by_email("unknown").must_equal :user_does_not_exist
    new_db.get_author(1).must_equal :author_does_not_exist
    new_db.get_author_by_name("unknown").must_equal :author_does_not_exist
    new_db.get_quote(1).must_equal :quote_does_not_exist
  end

  it "should be a user in database after reboot" do
    db = DB.new
    t = AddUser.new("John", "johnny@example.com", db)
    t.execute
    user_id = t.user_id
    user_id.wont_be_nil
    new_db = DB.new
    new_db.get_all_users.length.must_equal 1
    user = new_db.get_user(user_id)
    user.name.must_equal "John"
    user.email.must_equal "johnny@example.com"
    user.quotes.must_equal []
  end

  it "should be an author in database after reboot" do
    db = DB.new
    t = AddAuthor.new("Kent Beck", db)
    t.execute
    author_id = t.author_id
    new_db = DB.new
    author = new_db.get_author(author_id)
    new_db.get_all_authors.length.must_equal 1
    author.name.must_equal "Kent Beck"
    author.id.must_equal author_id
  end

  it "should have a quote after reboot" do
    db = DB.new
    t = AddAuthor.new("Kent Beck", db)
    t.execute
    u = AddUser.new("bill", "billy@example.com", db)
    u.execute
    user = db.get_user(u.user_id)
    author = db.get_author(t.author_id)
    text = "blubbbub"
    q = AddQuote.new(user.id, author.id, text, db)
    q.execute
    quote_id = q.quote_id
    new_db = DB.new
    quote = new_db.get_quote(quote_id)
    quote.text.must_equal text
    quote.user.must_equal user
    quote.author.must_equal author
  end

  it "should have a like after reboot" do
    db = DB.new
    t = AddAuthor.new("Hal Abelson", db)
    t.execute
    author = db.get_author(t.author_id)
    u = AddUser.new("jb", "jb@example.com", db)
    u.execute
    user = db.get_user(u.user_id)
    q = AddQuote.new(user.id, author.id, "blub", db)
    q.execute
    quote = db.get_quote(q.quote_id)
    l = UserLikesQuote.new(user.id, quote.id, db)
    l.execute
    new_db = DB.new
    user = new_db.get_user(quote.user.id)
    user.likes.wont_be_nil
    user.likes.to_a.length.must_equal 1
  end

  it "should have a dislike after reboot" do
    db = DB.new
    t = AddAuthor.new("Hal Abelson", db)
    t.execute
    author = db.get_author(t.author_id)
    u = AddUser.new("jb", "jb@example.com", db)
    u.execute
    user = db.get_user(u.user_id)
    q = AddQuote.new(user.id, author.id, "blub", db)
    q.execute
    quote = db.get_quote(q.quote_id)
    l = UserDislikesQuote.new(user.id, quote.id, db)
    l.execute
    new_db = DB.new
    user = new_db.get_user(quote.user.id)
    user.dislikes.wont_be_nil
    user.dislikes.to_a.length.must_equal 1
  end

  it "should have an image after reboot" do
    db = DB.new
    t = AddAuthor.new("Uncle Bob", db)
    t.execute
    author = db.get_author(t.author_id)
    url = "http://awesome.png"
    i = AddImage.new(author.id, url, db)
    i.execute
    new_db = DB.new
    new_author = new_db.get_author(t.author_id)
    new_author.image.wont_be_nil
    new_author.image.src.must_equal url
  end
end
end
