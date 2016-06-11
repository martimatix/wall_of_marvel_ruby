require_relative 'services/comics_info_getter'
require_relative 'services/cover_downloader'
require_relative 'services/montage_maker'
require_relative 'services/s3_uploader'

puts 'Starting Wall of Marvel'

puts 'Getting comics info'
comics_info = ComicsInfoGetter.new.perform

CoverDownloader.new(comics_info).perform

puts 'Making montage'
MontageMaker.new.perform

puts 'Uploading montage to S3'
S3Uploader.new('montage.jpg').perform

puts 'Done!'
