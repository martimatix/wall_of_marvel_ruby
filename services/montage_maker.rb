require 'rmagick'

class MontageMaker
  include Magick

  COVERS_IN_MONTAGE = 12
  JPG_COMPRESSION = 80
  MONTAGE_BORDER_GEOMETRY = '+2+2'
  MONTAGE_TILING = '6x2'

  def initialize(covers_folder_path, montage_file_path)
    @covers_folder_path = covers_folder_path
    @montage_file_path = montage_file_path
  end

  def perform
    return :error if image_list.length < COVERS_IN_MONTAGE
    collage.write(@montage_file_path) do
      self.interlace = Magick::LineInterlace
      self.quality = JPG_COMPRESSION
    end
    :ok
  end

  private

  def collage
    @collage ||= image_list.montage do |montage|
      montage.geometry = MONTAGE_BORDER_GEOMETRY
      montage.tile = MONTAGE_TILING
    end
  end

  def image_list
    @image_list ||= Magick::ImageList.new(*Dir["#{@covers_folder_path}/*.png"].sample(COVERS_IN_MONTAGE))
  end
end
