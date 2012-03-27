class AddImage
  def initialize(author_id, image_path, db)
    @author_id = author_id
    @image_path = image_path
    @db = db
  end

  def execute
    author = @db.get_author(@author_id)
    if author.image
      author.image.update(src: @image_path)
    else
      image = Image.new(src: @image_path)
      author.image = image
      @db.add_image(image)
    end
  end
end
