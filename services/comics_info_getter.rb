require 'httparty'
require_relative 'options_generator'
require 'pry'

class ComicsInfoGetter
  OLDEST_COMIC_THRESHOLD = 30
  NEWEST_COMIC_THRESHOLD = -30

  include HTTParty
  base_uri 'http://gateway.marvel.com'

  def perform
    comics_info.compact
  end

  private

  def comics_info
    latest_comics.map do |comic|
      comic_id = comic['id']
      comic_cover_path = comic.dig('thumbnail', 'path')
      if image_avilable?(comic_cover_path)
        image_url = "#{comic_cover_path}.#{comic.dig('thumbnail', 'extension')}"
        { comic_id: comic_id, image_url: image_url }
      end
    end
  end

  def image_avilable?(comic_cover_path)
    comic_cover_path.split('/').last != 'image_not_available'
  end

  def latest_comics
    results.select do |comic|
      onsale_date = comic['dates']&.first['date']
      comic_is_recent?(onsale_date)
    end
  end

  def comic_is_recent?(onsale_date)
    if onsale_date
      age_of_comic_in_days = Date.today - Date.parse(onsale_date)
      age_of_comic_in_days > NEWEST_COMIC_THRESHOLD and
        age_of_comic_in_days < OLDEST_COMIC_THRESHOLD
    end
  end

  def results
    marvel_comic_data.parsed_response.dig('data', 'results')
  end

  def marvel_comic_data
    self.class.get('/v1/public/comics', options)
  end

  def options
    OptionsGenerator.new.perform
  end
end
