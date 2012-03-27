require_relative "../core/get_users"

class UsersPresenter
  def initialize(view, db)
    @view = view
    @db = db
  end

  def update_view
    gu = GetUsers.new(@db)
    gu.execute
    @view.users = extract_users_model(gu.users)
  end

  def extract_users_model(users)
    users_model = []
    users = order_desc(users)
    users.each do |user|
      user_model = {}
      user_model[:name] = user.name
      user_model[:id] = user.id
      user_model[:score] = user.score
      user_quote = user.best_quote
      if user_quote
        user_model[:quote] = user_quote.text
        user_model[:quote_id] = user_quote.id
        user_model[:likes] = user_quote.likes.length
        user_model[:dislikes] = user_quote.dislikes.length
        user_model[:author] = user_quote.author.name
        user_model[:author_id] = user_quote.author.id
        user_model[:author_img_src] = user_quote.author.image.src if user_quote.author.image
      end
      users_model << user_model
    end
    users_model
  end

  def order_desc(users)
    users.sort_by do |user|
      user.score
    end.reverse!
  end
end
