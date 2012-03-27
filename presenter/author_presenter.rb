class AuthorPresenter
  def initialize(author_id, view, db)
    @author_id = author_id
    @view = view
    @db = db
  end

  def update_view
    author = @db.get_author(@author_id)
    quotes = author.quotes
    @view.author = extract_model_author(author)
    @view.quotes = extract_model_quotes(quotes)
  end

  def extract_model_author(author)
    author_model = {}
    author_model[:name] = author.name
    author_model[:id] = author.id
    author_model[:img_src] = author.image.src if author.image
    author_model
  end

  def extract_model_quotes(quotes)
    quotes_model = []
    quotes.each do |quote|
      quote_model = {}
      quote_model[:id] = quote.id
      quote_model[:text] = quote.text
      quote_model[:likes] = quote.likes.count
      quote_model[:dislikes] = quote.dislikes.count
      quote_model[:user_id] = quote.user.id
      quote_model[:user_name] = quote.user.name
      quotes_model << quote_model
    end
    quotes_model
  end
end
