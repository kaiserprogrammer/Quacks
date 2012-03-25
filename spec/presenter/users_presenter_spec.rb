require "minitest/autorun"
require_relative "../../presenter/users_presenter"
require_relative "../../core/memory_db"
require_relative "../../core/add_author"
require_relative "../../core/add_user"
require_relative "../../core/add_quote"
require_relative "../../core/add_image"
require_relative "../../core/user_likes_quote"

class MockUsersView
  attr_accessor :users
end

describe UsersPresenter do
  attr_reader :db, :view, :presenter, :author, :author2, :user, :text
  before(:each) do
    @db = InMemoryDB.new
    @view = MockUsersView.new
    @presenter = UsersPresenter.new(view, db)

    aa = AddAuthor.new("bill", db)
    aa.execute
    @author = db.get_author(aa.author_id)

    aa2 = AddAuthor.new("bill", db)
    aa2.execute
    @author2 = db.get_author(aa2.author_id)

    au = AddUser.new("john", "johny@example.com", db)
    au.execute
    @user = db.get_user(au.user_id)
    @text = "Awesome"
  end

  it "should pass the users to the view" do
    presenter.update_view
    view.users.first[:name].must_equal user.name
    view.users.first[:id].must_equal user.id
    view.users.first[:score].must_equal 0

    au2 = AddUser.new("billy", "billy@example.com", db)
    au2.execute
    user2 = db.get_user(au2.user_id)

    presenter.update_view
    view.users.length.must_equal 2
  end

  it "should have highest quote" do
    presenter.update_view
    view.users.first[:score].must_equal 0
    view.users.first[:quote].must_be_nil
    view.users.first[:quote_id].must_be_nil
    view.users.first[:likes].must_be_nil
    view.users.first[:dislikes].must_be_nil
    view.users.first[:author].must_be_nil
    view.users.first[:author_id].must_be_nil
    view.users.first[:author_img_src].must_be_nil

    aq = AddQuote.new(user.id, author.id, text, db)
    aq.execute
    quote = db.get_quote(aq.quote_id)

    presenter.update_view
    view.users.first[:score].must_equal 0
    view.users.first[:quote].must_equal text
    view.users.first[:quote_id].must_equal quote.id
    view.users.first[:likes].must_equal quote.likes.length
    view.users.first[:dislikes].must_equal quote.dislikes.length
    view.users.first[:author].must_equal author.name
    view.users.first[:author_id].must_equal author.id
    view.users.first[:author_img_src].must_be_nil

    aq2 = AddQuote.new(user.id, author2.id, text + "2", db)
    aq2.execute
    quote2 = db.get_quote(aq2.quote_id)

    ulq = UserLikesQuote.new(user.id, quote2.id, db)
    ulq.execute

    presenter.update_view
    view.users.first[:score].must_equal 1
    view.users.first[:quote].must_equal text + "2"
    view.users.first[:quote_id].must_equal quote2.id
    view.users.first[:likes].must_equal quote2.likes.length
    view.users.first[:dislikes].must_equal quote2.dislikes.length
    view.users.first[:author].must_equal author2.name
    view.users.first[:author_id].must_equal author2.id
    view.users.first[:author_img_src].must_be_nil

    au2 = AddUser.new("jim", "jim@example.com", db)
    au2.execute
    user2 = db.get_user(au2.user_id)
    aq3 = AddQuote.new(user2.id, author2.id, text + "3", db)
    aq3.execute
    quote3 = db.get_quote(aq3.quote_id)
    aq4 = AddQuote.new(user2.id, author2.id, text + "4", db)
    aq4.execute
    quote4 = db.get_quote(aq4.quote_id)

    ulq2 = UserLikesQuote.new(user.id, quote3.id, db)
    ulq2.execute
    ulq3 = UserLikesQuote.new(user2.id, quote3.id, db)
    ulq3.execute
    ulq4 = UserLikesQuote.new(user2.id, quote4.id, db)
    ulq4.execute

    presenter.update_view
    view.users.first[:score].must_equal 3
    view.users.first[:name].must_equal user2.name
    view.users.first[:id].must_equal user2.id
    view.users.first[:quote].must_equal text + "3"
    view.users.first[:quote_id].must_equal quote3.id
    view.users.first[:likes].must_equal quote3.likes.length
    view.users.first[:dislikes].must_equal quote3.dislikes.length
    view.users.first[:author].must_equal author2.name
    view.users.first[:author_id].must_equal author2.id
    view.users.first[:author_img_src].must_be_nil
  end

  it "should pass image of author" do
    ai = AddImage.new(author.id, "blub", db)
    ai.execute
    aq = AddQuote.new(user.id, author.id, text, db)
    aq.execute
    quote = db.get_quote(aq.quote_id)

    presenter.update_view
    view.users.first[:quote].must_equal text
    view.users.first[:quote_id].must_equal quote.id
    view.users.first[:likes].must_equal quote.likes.length
    view.users.first[:dislikes].must_equal quote.dislikes.length
    view.users.first[:author].must_equal author.name
    view.users.first[:author_id].must_equal author.id
    view.users.first[:author_img_src].must_equal author.image.src
  end
end
