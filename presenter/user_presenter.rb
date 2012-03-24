class UserPresenter
  def initialize(user_id, view, db)
    @user_id = user_id
    @view = view
    @db = db
  end

  def update_view
    user = @db.get_user(@user_id)
    quotes = user.quotes
    liked_quotes = user.likes.collect(&:quote)
    disliked_quotes = user.dislikes.collect(&:quote)
    @view.user = extract_user_model(user)
    @view.quotes = extract_quotes_model(quotes)
    @view.likes = extract_quotes_model(liked_quotes)
    @view.dislikes = extract_quotes_model(disliked_quotes)
  end

  def extract_user_model(user)
    {:name => user.name}
  end

  def extract_quotes_model(quotes)
    quotes_model = []
    quotes.each do |quote|
      quote_model = {}
      quote_model[:text] = quote.text
      quote_model[:id] = quote.id
      quote_model[:likes] = quote.likes.length
      quote_model[:dislikes] = quote.dislikes.length
      quote_model[:author_id] = quote.author.id
      quote_model[:author_name] = quote.author.name
      quote_model[:author_img_src] = quote.author.image.src if quote.author.image
      quotes_model << quote_model
    end
    quotes_model
  end
end
