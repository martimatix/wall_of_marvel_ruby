require_relative 'services/comics_info_getter'
require_relative 'services/cover_downloader'
require_relative 'services/montage_maker'

puts 'Starting Wall of Marvel'
comics_info = ComicsInfoGetter.new.perform
CoverDownloader.new(comics_info).perform
MontageMaker.new.perform
puts 'Done!'
