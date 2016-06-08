require 'rmagick'

# TODO: Deal with horizontal images
class MontageMaker
  include Magick

  def scale_all_images
    Dir["covers/*.jpg"].sample(12).each_with_index do |location, index|
      scale_image(location, index)
    end
  end

  def scale_image(location, index)
    img = Magick::Image.read(location).first
    # TODO: Remove magic numbers
    # img.resize!(150, 225, WelshFilter)
    # img.resize!(280, 425, WelshFilter)
    img.resize!(320, 486, WelshFilter)
    img.write("scaled_covers/#{index}.png")
  end

  def make_collage
    image_list = Magick::ImageList.new(*Dir["scaled_covers/*.png"])
    collage = image_list.montage do |mont|
      mont.geometry = '+2+2'
      mont.tile = '6x2'
    end
    # collage.write('montages/test.png')
    collage.write('montages/montage.jpg') { self.quality = 60 }
    # collage.write('montages/test.jpg') { self.quality = 85 }
  end
end

mm = MontageMaker.new
mm.scale_all_images
mm.make_collage
