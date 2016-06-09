require 'rmagick'
require 'mathn'

class CoverDownloader
  include Magick

  MIN_RATIO = 549/850
  MAX_RATIO = 580/850
  SCALED_COMIC_WIDTH = 320
  SCALED_COMIC_HEIGHT = 486
  COVERS_TO_DOWNLOAD = 30

  def initialize(comics_info)
    @comics_info = comics_info
  end

  def perform
    @comics_info.sample(COVERS_TO_DOWNLOAD).each do |comic_info|
      image_url, comic_id = comic_info[:image_url], comic_info[:comic_id]
      save_and_scale_image(image_url, comic_id) if dimensions_ok?(image_url)
    end
  end

  private

  def dimensions_ok?(image_url)
    image = Magick::Image.ping(image_url).first
    ratio = image.columns/image.rows
    ratio >= MIN_RATIO && ratio <= MAX_RATIO
  end

  def save_and_scale_image(image_url, comic_id)
    puts "Saving and scaling #{comic_id}"
    image = Magick::Image.read(image_url).first
    image.resize!(SCALED_COMIC_WIDTH, SCALED_COMIC_HEIGHT, WelshFilter)
    image.write("covers/#{comic_id}.png")
  end
end
