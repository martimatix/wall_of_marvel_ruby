require 'digest'
require 'dotenv'
Dotenv.load

class OptionsGenerator
  def perform
    randomize_options
    options
  end

  private

  def randomize_options
    randomize_date_descriptor
    randomize_order_by
  end

  def randomize_date_descriptor
    options[:dateDescriptor] = ['lastWeek',
                                'thisWeek',
                                'nextWeek',
                                'thisMonth'].sample
  end

  def randomize_order_by
    options[:orderBy] = ['focDate',
                         'onsaleDate',
                         'title',
                         'issueNumber',
                         'modified',
                         '-focDate',
                         '-onsaleDate',
                         '-title',
                         '-issueNumber',
                         '-modified'].sample
  end

  def options
    @options ||= {
      query: {
        format: 'comic',
        formatType: 'comic',
        noVariants: 'true',
        limit: 60,
        ts: time_stamp,
        apikey: ENV['API_KEY'],
        hash: secruity_hash
      }
    }
  end

  def time_stamp
    @time_stamp ||= Time.now.to_i.to_s
  end

  def secruity_hash
    Digest::MD5.hexdigest(time_stamp + ENV['API_SECRET'] + ENV['API_KEY'])
  end
end
