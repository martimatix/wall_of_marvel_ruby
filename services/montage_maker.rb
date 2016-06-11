require 'rmagick'

class MontageMaker
  include Magick

  COVERS_IN_MONTAGE = 12
  JPG_COMPRESSION = 60
  MONTAGE_BORDER_GEOMETRY = '+2+2'
  MONTAGE_TILING = '6x2'
  MONTAGE_FILE_PATH = 'montage.jpg'

  def perform
    collage.write(MONTAGE_FILE_PATH) { self.quality = JPG_COMPRESSION }
    MONTAGE_FILE_PATH
  end

  private

  def collage
    @collage ||= image_list.montage do |montage|
      montage.geometry = MONTAGE_BORDER_GEOMETRY
      montage.tile = MONTAGE_TILING
    end
  end

  def image_list
    @image_list ||= Magick::ImageList.new(*Dir['covers/*.png'].sample(COVERS_IN_MONTAGE))
  end
end
