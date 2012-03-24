class GetUsers
  attr_accessor :users

  def initialize(db)
    @db = db
  end

  def execute
    @users = @db.get_all_users
  end
end
