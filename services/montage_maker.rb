require 'rmagick'

class MontageMaker
  include Magick

  def perform
    puts 'Making montage'
    image_list = Magick::ImageList.new(*Dir['covers/*.png'].sample(12))
    collage = image_list.montage do |montage|
      montage.geometry = '+2+2'
      montage.tile = '6x2'
    end
    collage.write('montage.jpg') { self.quality = 60 }
  end
end
