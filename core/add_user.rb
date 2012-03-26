require_relative "user"

class AddUser
  attr_reader :user_id

  def initialize(name, email, db)
    @name = name
    @email = email
    @db = db
  end

  def execute
    user = @db.get_user_by_email(@email)
    if user == :user_does_not_exist
      user = User.new(@name, @email)
      @db.add_user(user)
    end
    @user_id = user.id
  end
end
