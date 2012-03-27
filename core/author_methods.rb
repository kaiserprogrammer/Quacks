module AuthorMethods
  def best_quote
    quotes.max_by { |quote| quote.likes.length }
  end
end
