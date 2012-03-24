require "minitest/autorun"
require_relative "../../presenter/author_presenter"
require_relative "../core/memory_db"
require_relative "../../core/add_author"
require_relative "../../core/add_user"
require_relative "../../core/add_image"
require_relative "../../core/add_quote"
require_relative "../../core/user_likes_quote"
require_relative "../../core/user_dislikes_quote"

class MockAuthorView
  attr_accessor :author, :quotes
  def initialize
    @author = {}
  end
end

describe AuthorPresenter do
  attr_reader :author_id, :user_id, :db, :view, :presenter

  before(:each) do
    @db = InMemoryDB.new
    t = AddAuthor.new("Uncle Bob", db)
    t.execute
    @author_id = t.author_id

    au = AddUser.new("Bill", "billy@example.com", db)
    au.execute
    @user_id = au.user_id

    @view = MockAuthorView.new
    @presenter = AuthorPresenter.new(author_id, view, db)
  end

  it "should pass name and id to view" do
    presenter.update_view
    view.quotes.must_equal []
    view.author[:name].must_equal "Uncle Bob"
    view.author[:id].must_equal author_id
  end

  it "should not have an image src" do
    presenter.update_view
    view.author[:img_src].must_be_nil
  end

  it "should have an image src" do
    t = AddImage.new(author_id, "src", db)
    t.execute
    presenter.update_view
    view.author[:img_src].must_equal "src"
  end

  it "should pass quotes to view" do
    text = "Have a nice day!"
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    quote_id = aq.quote_id
    aq = AddQuote.new(user_id, author_id, text + "1", db)
    aq.execute
    quote2_id = aq.quote_id
    presenter.update_view
    view.quotes.first[:text].must_equal text
    view.quotes.first[:likes].must_equal 0
    view.quotes.first[:dislikes].must_equal 0
    view.quotes.first[:id].must_equal quote_id
    view.quotes[1][:id].must_equal quote2_id
  end

  it "should count likes for quotes" do
    text = "Have a nice day!"
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    quote_id = aq.quote_id
    ulq = UserLikesQuote.new(user_id, quote_id, db)
    ulq.execute

    presenter.update_view

    view.quotes.first[:likes].must_equal 1
    view.quotes.first[:dislikes].must_equal 0
  end

  it "should count dislikes for quotes" do
    text = "Have a nice day!"
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute
    quote_id = aq.quote_id
    ulq = UserDislikesQuote.new(user_id, quote_id, db)
    ulq.execute

    presenter.update_view

    view.quotes.first[:likes].must_equal 0
    view.quotes.first[:dislikes].must_equal 1
  end

  it "should include user name and id" do
    text = "Have a nice day"
    aq = AddQuote.new(user_id, author_id, text, db)
    aq.execute

    presenter.update_view
    view.quotes.first[:user_id].must_equal user_id
    view.quotes.first[:user_name].must_equal db.get_user(user_id).name
  end
end
