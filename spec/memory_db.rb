require "log4r"

include Log4r

class InMemoryDB
  attr_reader :transactions

  def initialize
    @authors_names = {}
    @authors = {}
    @users = {}
    @quotes = {}
    @id = 0
    @transactions = Logger.new("transaction_db")
    @transactions.outputters = FileOutputter.new("log_info", :filename => "transactions", :level => INFO)
  end

  def id
    @id += 1
  end

  def get_all_authors
    @authors.values
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

  def get_user(id)
    @users[id]
  end

  def add_user(user)
    @users[id] = user
    user.id = @id
  end

  def get_quote(id)
    @quotes[id]
  end

  def add_quote(quote)
    @quotes[id] = quote
    quote.id = @id
  end
end
