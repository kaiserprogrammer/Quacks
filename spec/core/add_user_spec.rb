require "minitest/autorun"
require_relative "../../core/add_user"
require_relative "../../core/memory_db"

describe AddUser do
  it "should add a user" do
    db = InMemoryDB.new
    name = "Josh"
    email = "johny@example.com"
    t = AddUser.new(name, email, db)
    t.execute

    id = t.user_id
    user = db.get_user(id)
    user.name.must_equal name
    user.email.must_equal email
  end

  it "should not overwrite an existing user" do
    db = InMemoryDB.new
    name = "Bill"
    email = "billy@example.com"
    t = AddUser.new(name, email, db)
    t.execute

    id = t.user_id
    user = db.get_user(id)
    user.name.must_equal name
    user.email.must_equal email

    t2 = AddUser.new(name, email, db)
    t2.execute

    id2 = t2.user_id
    user2 = db.get_user(id2)
    user2.must_be_same_as user
  end

  it "should not update user id" do
    db = InMemoryDB.new
    name = "bill"
    email = "bill@example.com"
    t = AddUser.new(name, email, db)
    t.execute
    id = t.user_id

    t = AddUser.new(name, email, db)
    t.execute
    id2 = t.user_id

    id2.must_equal id
  end
end
