require_relative "user"

class AddUser
  attr_reader :user_id

  def initialize(name, email, db)
    @name = name
    @email = email
    @db = db
    db.transactions.info("#{self.class},;,#{name},;,#{email}")
  end

  def execute
    user = User.new(@name, @email)
    @db.add_user(user)
    @user_id = user.id
  end
end
