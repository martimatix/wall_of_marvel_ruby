require 'digest'
require 'dotenv'
Dotenv.load

class OptionsGenerator

  def perform
    options
  end

  private

  def options
    @options ||= {
      query: {
        format: 'comic',
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
