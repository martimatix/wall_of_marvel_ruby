require 's3'
require 'dotenv'
Dotenv.load

class S3Uploader
  BUCKET_NAME = 'comicbookwall'
  S3_FILE_NAME = 'montage.jpg'
  IMAGE_CONTENT_TYPE = 'image/jpg'
  FILE_ACL = :public_read

  def initialize(file_path)
    @file_path = file_path
  end

  def perform
    bucket = service.buckets.find(BUCKET_NAME)
    file = bucket.objects.build(S3_FILE_NAME)
    file.content = open(@file_path)
    file.acl = FILE_ACL
    file.content_type = IMAGE_CONTENT_TYPE
    file.save
  end

  private

  def service
    @service ||= S3::Service.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                 secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
