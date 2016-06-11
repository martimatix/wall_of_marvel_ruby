require 'rmagick'

class MontageMaker
  include Magick

  COVERS_IN_MONTAGE = 12
  JPG_COMPRESSION = 60
  MONTAGE_BORDER_GEOMETRY = '+2+2'
  MONTAGE_TILING = '6x2'

  def perform
    image_list = Magick::ImageList.new(*Dir['covers/*.png'].sample(COVERS_IN_MONTAGE))
    collage = image_list.montage do |montage|
      montage.geometry = MONTAGE_BORDER_GEOMETRY
      montage.tile = MONTAGE_TILING
    end
    collage.write('montage.jpg') { self.quality = JPG_COMPRESSION }
  end
end
