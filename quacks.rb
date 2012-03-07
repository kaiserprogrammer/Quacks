module Quacks
  @quotes = Hash.new []
  @images = {}

  def self.reset
    reset_quotes
    reset_images
  end

  def self.reset_quotes
    @quotes = Hash.new []
  end

  def self.reset_images
    @images = {}
  end

  def self.quotes_for_author name
    @quotes.fetch(name) { [] }
  end

  def self.save_quote name, quote
    @quotes[name] = (@quotes[name] + [quote]).uniq
  end

  def self.all_quotes
    acc_quotes = []
    @quotes.each do |name, quotes|
      acc_quotes.concat quotes
    end
    acc_quotes
  end

  def self.save_image name, image_path
    @images[name] = image_path
  end

  def self.image_path_of_author name
    @images.fetch(name)
  end
end
