class Dislike
  attr_reader :user, :quote

  def initialize(fields={})
    @user = fields[:user]
    @quote = fields[:quote]
  end
end
