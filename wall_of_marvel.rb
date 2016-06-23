require_relative 'services/comics_info_getter'
require_relative 'services/cover_downloader'
require_relative 'services/montage_maker'
require_relative 'services/s3_uploader'
require 'fileutils'

def directory_exists?(directory)
  File.directory?(directory)
end

COVERS_FOLDER_PATH = 'tmp/covers'
MONTAGE_FILE_PATH = 'tmp/montage.jpg'

puts 'Starting Wall of Marvel'

puts 'Getting comics info'
comics_info = ComicsInfoGetter.new.perform

FileUtils.remove_entry COVERS_FOLDER_PATH if directory_exists?(COVERS_FOLDER_PATH)
FileUtils.mkdir COVERS_FOLDER_PATH

CoverDownloader.new(comics_info, COVERS_FOLDER_PATH).perform

puts 'Making montage'
status = MontageMaker.new(COVERS_FOLDER_PATH, MONTAGE_FILE_PATH).perform

case status
when :ok
  puts 'Uploading montage to S3'
  S3Uploader.new(MONTAGE_FILE_PATH).perform
  FileUtils.remove_entry MONTAGE_FILE_PATH
  puts 'Done!'
when :error
  puts 'ERROR: Not enough images to make montage'
else :error
  puts 'ERROR: Something unexpected happened'
end

FileUtils.remove_entry COVERS_FOLDER_PATH
