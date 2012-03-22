module Quacks
  def self.quotes_for_author name, db
    db.quotes.fetch(name) { [] }
  end

  def self.save_quote name, quote, db
    (db.quotes[name] << quote).uniq!
  end

  def self.save_image name, image_path, db
    db.images[name] = image_path
  end

  def self.image_path_of_author name, db
    db.images.fetch(name)
  end
end
