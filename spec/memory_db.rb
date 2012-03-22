class InMemoryDB
  def initialize
    @authors_names = {}
    @authors = {}
    @id = 0
  end

  def id
    @id += 1
  end

  def get_author(id)
    @authors.fetch(id) { :author_does_not_exist }
  end

  def get_author_by_name(name)
    @authors_names.fetch(name) { :author_does_not_exist }
  end

  def add_author(name, author)
    @authors_names[name] = author
    @authors[id] = author
    author.id = @id
  end
end
