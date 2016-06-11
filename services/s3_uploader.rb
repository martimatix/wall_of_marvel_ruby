require 's3'
require 'dotenv'
Dotenv.load

class S3Uploader
  def initialize(montage_file_path)
    @montage_file_path = montage_file_path
  end

  def perform
    bucket = service.buckets.find('comicbookwall')
    montage = bucket.objects.build('montage.jpg')
    montage.content = open(@montage_file_path)
    montage.acl = :public_read
    montage.content_type = 'image/jpg'
    montage.save
  end

  private

  def service
    @service ||= S3::Service.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                 secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
