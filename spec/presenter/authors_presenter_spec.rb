require "minitest/autorun"
require_relative "../../core/add_author"
require_relative "../../core/add_quote"
require_relative "../../core/add_user"
require_relative "../../core/add_image"
require_relative "../../core/user_likes_quote"
require_relative "../../presenter/authors_presenter"
require_relative "../../core/memory_db"

class MockAuthorsView
  attr_accessor :authors

  def initialize
    @authors = []
  end
end

describe AuthorsPresenter do
  attr_reader :db, :view, :presenter, :author, :user

  before(:each) do
    @view = MockAuthorsView.new
    @db = InMemoryDB.new
    @presenter = AuthorsPresenter.new(@view, @db)

    t = AddAuthor.new("Beck", db)
    t.execute
    author_id = t.author_id
    @author = db.get_author(author_id)

    au = AddUser.new("Bill", "billy@example.com", db)
    au.execute
    user_id = au.user_id
    @user = db.get_user(user_id)
  end

  it "should pass the authors to the view" do
    presenter.update_view
    h = {:name => "Beck", :id => author.id}
    view.authors.first.must_equal h
    t2 = AddAuthor.new("Bob", db)
    t2.execute

    presenter.update_view
    view.authors.length.must_equal 2
  end

  it "should retrieve quote from author" do
    text = "How nice of you"
    t = AddQuote.new(user.id, author.id, text, db)
    t.execute

    presenter.update_view
    view.authors.first[:quote].must_equal text
  end

  it "should retrieve the most liked quote from author" do
    text = "How nice of you"
    t = AddQuote.new(user.id, author.id, text + "1", db)
    t.execute
    t2 = AddQuote.new(user.id, author.id, text, db)
    t2.execute
    t3 = AddQuote.new(user.id, author.id, text + "2", db)
    t3.execute

    quote_id = t2.quote_id
    quote = db.get_quote(quote_id)

    ulq = UserLikesQuote.new(user.id, quote.id, db)
    ulq.execute
    presenter.update_view
    view.authors.first[:quote].must_equal text
  end

  it "should retrieve not set image when there is none of author" do
    presenter.update_view
    view.authors.first[:img_src].must_be_nil
  end

  it "should set image of author" do
    path = "blub"
    t = AddImage.new(@author.id, path, db)
    t.execute

    presenter.update_view
    view.authors.first[:img_src].must_equal path
  end
end
