require 'digest'
require 'dotenv'
Dotenv.load

class OptionsGenerator
  COMICS_LIMIT = 100
  OFFSET = 100

  def perform
    randomize_date_descriptor
    options
  end

  private

  def randomize_date_descriptor
    options[:dateDescriptor] = ['lastWeek',
                                'thisWeek',
                                'nextWeek',
                                'thisMonth'].sample
  end

  def options
    @options ||= {
      query: {
        format: 'comic',
        formatType: 'comic',
        noVariants: 'false',
        limit: COMICS_LIMIT,
        offset: OFFSET,
        ts: time_stamp,
        apikey: ENV['API_KEY'],
        hash: secruity_hash
      },
      orderBy: 'onsaleDate'
    }
  end

  def time_stamp
    @time_stamp ||= Time.now.to_i.to_s
  end

  def secruity_hash
    Digest::MD5.hexdigest(time_stamp + ENV['API_SECRET'] + ENV['API_KEY'])
  end
end
