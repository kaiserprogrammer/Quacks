class AddQuote
  def initialize(author_id, quote, db)
    @author_id = author_id
    @quote = quote
    @db = db
  end

  def execute
    author = @db.get_author(@author_id)
    author.quotes << @quote
  end
end
