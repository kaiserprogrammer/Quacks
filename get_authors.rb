class GetAuthors
  attr_reader :authors

  def initialize(db)
    @db = db
  end

  def execute
    @authors = @db.get_all_authors
  end
end
