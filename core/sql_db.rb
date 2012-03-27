class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String

  has n, :likes
  has n, :dislikes
  has n, :quotes
end

class Author
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :quotes
  has 1, :image
end

class Like
  include DataMapper::Resource

  property :id, Serial

  belongs_to :user
  belongs_to :quote
end

class Dislike
  include DataMapper::Resource

  property :id, Serial

  belongs_to :user
  belongs_to :quote
end

class Quote
  include DataMapper::Resource

  property :id, Serial
  property :text, String

  has n, :likes
  has n, :dislikes
  belongs_to :user
  belongs_to :author
end

class Image
  include DataMapper::Resource

  property :id, Serial
  property :src, String

  belongs_to :author
end

class SQLDB

  def add_user(user)
    user.save
  end

  def get_user(id)
    User.get(id) || :user_does_not_exist
  end

  def get_all_users
    User.all
  end

  def add_author(author)
    author.save
  end

  def get_author(id)
    Author.get(id) || :author_does_not_exist
  end

  def get_all_authors
    Author.all
  end

  def get_author_by_name(name)
    :author_does_not_exist
  end

  def get_quote(id)
    Quote.get(id) || :quote_does_not_exist
  end

  def get_user_by_email(email)
    :user_does_not_exist
  end

  def add_quote(quote)
    quote.save
  end

  def add_image(image)
    image.save
  end

  def add_like(like)
    like.save
  end

  def add_dislike(dislike)
    dislike.save
  end
end

DataMapper.finalize
