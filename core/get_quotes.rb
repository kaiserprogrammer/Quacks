class GetQuotes
  def initialize(author_id, db)
    @author_id = author_id
    @db = db
    @quotes = []
  end

  def execute
    author = @db.get_author(@author_id)
    @quotes = author.quotes if author != :author_does_not_exist
  end

  def quotes
    @quotes
  end
end
