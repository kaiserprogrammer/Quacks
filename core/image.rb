class Image
  attr_reader :src

  def initialize(fields={})
    @src = fields[:src]
  end

  def update(fields={})
    @src = fields[:src]
  end
end
