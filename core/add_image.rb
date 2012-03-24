require_relative "image"

class AddImage
  def initialize(author_id, image_path, db)
    @author_id = author_id
    @image_path = image_path
    @db = db
    db.transactions.info("#{self.class},;,#{author_id},;,#{image_path}")
  end

  def execute
    author = @db.get_author(@author_id)
    author.image = Image.new(@image_path)
  end
end
