class Image
  attr_reader :src

  def initialize(fields={})
    @src = fields[:src]
  end
end
