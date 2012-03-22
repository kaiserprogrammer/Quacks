require_relative "author"

class AddAuthor
  attr_reader :author_id

  def initialize(name, db)
    @db = db
    @name = name
  end

  def execute
    author = @db.get_author_by_name(@name)
    if author  == :author_does_not_exist
      author = Author.new(@name)
      @db.add_author(@name, author)
    end

    @author_id = author.id
  end
end
