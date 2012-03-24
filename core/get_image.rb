class GetImage
  def initialize(author_id, db)
    @author_id = author_id
    @db = db
  end

  def execute
    author = @db.get_author(@author_id)
    @url = author.image.src
  end

  def url
    @url
  end
end
