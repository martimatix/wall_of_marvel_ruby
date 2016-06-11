require_relative 'services/comics_info_getter'
require_relative 'services/cover_downloader'
require_relative 'services/montage_maker'
require_relative 'services/s3_uploader'
require 'fileutils'

def directory_exists?(directory)
  File.directory?(directory)
end

COVERS_FOLDER_PATH = 'tmp/covers'

puts 'Starting Wall of Marvel'

puts 'Getting comics info'
comics_info = ComicsInfoGetter.new.perform

FileUtils.remove_entry COVERS_FOLDER_PATH if directory_exists?(COVERS_FOLDER_PATH)
FileUtils.mkdir COVERS_FOLDER_PATH

CoverDownloader.new(comics_info, COVERS_FOLDER_PATH).perform

puts 'Making montage'
montage_path = MontageMaker.new.perform

puts 'Uploading montage to S3'
S3Uploader.new(montage_path).perform

FileUtils.remove_entry COVERS_FOLDER_PATH
FileUtils.remove_entry montage_path

puts 'Done!'
