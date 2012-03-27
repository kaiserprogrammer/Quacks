require "minitest/autorun"
require_relative "../../presenter/user_presenter"
require_relative "../../core/current_db"
require_relative "../../core/add_user"
require_relative "../../core/add_author"
require_relative "../../core/add_quote"
require_relative "../../core/add_image"
require_relative "../../core/user_likes_quote"
require_relative "../../core/user_dislikes_quote"

class MockUserView
  attr_accessor :user, :quotes, :likes, :dislikes
end

describe UserPresenter do
  attr_reader :db, :view, :user, :presenter, :author, :text
  before(:each) do
    DB.auto_migrate!
    @db = DB.new
    @view = MockUserView.new
    t = AddUser.new("bill", "billy@example.com", db)
    t.execute
    @user = db.get_user(t.user_id)
    t = AddAuthor.new("Martin", db)
    t.execute
    @author = db.get_author(t.author_id)
    @presenter = UserPresenter.new(user.id, view, db)
    @text = "How about this"
    ai = AddImage.new(author.id, "blub", db)
    ai.execute
  end

  it "should get user's name" do
    presenter.update_view
    view.user[:name].must_equal user.name
  end

  it "should get all quotes" do
    aq = AddQuote.new(user.id, author.id, text, db)
    aq.execute
    quote_id = aq.quote_id
    quote = db.get_quote(quote_id)
    presenter.update_view
    check_quotes(view.quotes, 0, quote, author, 0, 0)

    aa = AddAuthor.new("Beck", db)
    aa.execute
    author2 = db.get_author(aa.author_id)

    aq2 = AddQuote.new(user.id, author2.id, text + "1", db)
    aq2.execute
    quote2 = db.get_quote(aq2.quote_id)
    presenter.update_view

    check_quotes(view.quotes, 0, quote, author, 0, 0)
    check_quotes(view.quotes, 1, quote2, author2, 0, 0)
  end

  it "should get all likes" do
    aq = AddQuote.new(user.id, author.id, text, db)
    aq.execute
    quote = db.get_quote(aq.quote_id)

    ulq = UserLikesQuote.new(user.id, quote.id, db)
    ulq.execute

    presenter.update_view
    check_quotes(view.quotes, 0, quote, author, 1, 0)

    aq2 = AddQuote.new(user.id, author.id, text + "1", db)
    aq2.execute
    quote2 = db.get_quote(aq2.quote_id)

    ulq2 = UserLikesQuote.new(user.id, quote2.id, db)
    ulq2.execute

    presenter.update_view
    check_quotes(view.quotes, 0, quote, author, 1, 0)
    check_quotes(view.quotes, 1, quote2, author, 1, 0)
    check_quotes(view.likes, 0, quote, author, 1, 0)
    check_quotes(view.likes, 1, quote2, author, 1, 0)
    view.dislikes.must_equal []
  end

  it "should get all dislikes" do
    aq = AddQuote.new(user.id, author.id, text, db)
    aq.execute
    quote = db.get_quote(aq.quote_id)

    ulq = UserDislikesQuote.new(user.id, quote.id, db)
    ulq.execute

    presenter.update_view
    check_quotes(view.quotes, 0, quote, author, 0, 1)

    aq2 = AddQuote.new(user.id, author.id, text + "1", db)
    aq2.execute
    quote2 = db.get_quote(aq2.quote_id)

    ulq2 = UserDislikesQuote.new(user.id, quote2.id, db)
    ulq2.execute

    presenter.update_view
    check_quotes(view.quotes, 0, quote, author, 0, 1)
    check_quotes(view.quotes, 1, quote2, author, 0, 1)
    check_quotes(view.dislikes, 0, quote, author, 0, 1)
    check_quotes(view.dislikes, 1, quote2, author, 0, 1)
    view.likes.must_equal []
  end

  def check_quotes(quotes, position, quote, author, likes, dislikes)
    quotes[position][:text].must_equal quote.text
    quotes[position][:id].must_equal quote.id
    quotes[position][:likes].must_equal likes
    quotes[position][:dislikes].must_equal dislikes
    quotes[position][:author_id].must_equal author.id
    quotes[position][:author_name].must_equal author.name
    quotes[position][:author_img_src].must_equal author.image.src if author.image
  end
end
