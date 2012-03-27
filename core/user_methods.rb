module UserMethods
  def score
    quotes.reduce(0) { |sum, quote| sum + quote.likes.length }
  end

  def best_quote
    quotes.max_by { |quote| quote.likes.length }
  end
end
