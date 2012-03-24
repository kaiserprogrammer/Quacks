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
    user = @db.get_user_by_email(@email)
    user = User.new(@name, @email) if user == :user_does_not_exist
    @db.add_user(user)
    @user_id = user.id
  end
end
