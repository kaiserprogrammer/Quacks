require "minitest/autorun"
require_relative "../../core/get_users"
require_relative "../../core/memory_db"
require_relative "../../core/add_user"

describe GetUsers do
  it "should get all users" do
    db = InMemoryDB.new

    gu = GetUsers.new(db)
    gu.execute
    gu.users.length.must_equal 0

    t = AddUser.new("Bill", "bill@example.com", db)
    t.execute
    user = db.get_user(t.user_id)

    gu.execute
    gu.users.first.must_equal user
    gu.users.length.must_equal 1

    t2 = AddUser.new("Bonny", "bonny@example.com", db)
    t2.execute

    gu.execute
    gu.users.length.must_equal 2
  end
end
