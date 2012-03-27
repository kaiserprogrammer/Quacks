require_relative "user"
require_relative "author"
require_relative "quote"
require_relative "image"
require_relative "dislike"
require_relative "like"

class InMemoryDB
  def initialize
    @authors_names = {}
    @authors = {}
    @users = {}
    @users_emails = {}
    @quotes = {}
    @id = 0
  end

  def id
    @id += 1
  end

  def get_all_authors
    @authors.values
  end

  def get_all_users
    @users.values
  end

  def get_author(id)
    @authors.fetch(id) { :author_does_not_exist }
  end

  def get_author_by_name(name)
    @authors_names.fetch(name) { :author_does_not_exist }
  end

  def add_author(author)
    @authors_names[author.name] = author
    @authors[id] = author
    author.id = @id
  end

  def get_user(id)
    @users.fetch(id) { :user_does_not_exist }
  end

  def get_user_by_email(email)
    @users_emails.fetch(email) { :user_does_not_exist }
  end

  def add_user(user)
    @users[id] = user
    @users_emails[user.email] = user
    user.id = @id
  end

  def get_quote(id)
    @quotes.fetch(id) { :quote_does_not_exist }
  end

  def add_quote(quote)
    @quotes[id] = quote
    quote.id = @id
  end

  def add_image(image)
  end

  def add_like(like)
  end

  def add_dislike(dislike)
  end
end
