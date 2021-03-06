require_relative "../core/get_authors"

class AuthorsPresenter
  def initialize(view, db)
    @view = view
    @db = db
  end

  def update_view
    t = GetAuthors.new(@db)
    t.execute

    authors_view_model = extract_view_model(t.authors)
    @view.authors = authors_view_model
  end

  def extract_view_model(authors)
    authors_model = []
    authors.each do |author|
      author_model = {}
      author_model[:name] = author.name
      author_model[:id] = author.id
      author_model[:img_src] = author.image.src if author.image
      author_model[:quote] = author.best_quote.text if author.quotes.length > 0
      authors_model << author_model
    end
    authors_model
  end
end
