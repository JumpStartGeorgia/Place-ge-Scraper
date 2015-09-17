require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require_relative 'ad'
require_relative 'helper'

# Group of place.ge real estate ads
class PlaceGeAdGroup
  def initialize
    @date = Date.today - 1

    @ad_ids = get_ad_ids
  end

  def to_s
    puts @ad_ids
  end

  def get_ad_ids
    link = "http://place.ge/ge/ads/page:1?object_type=all&currency_id=2&mode=list&order_by=date&limit=30"
    page = Nokogiri.HTML(open(link))

    ad_boxes = page.css('.tr-line')
    ad_ids = []

    ad_boxes.each do |ad_box|
      if date_matches_ad_box?(ad_box)
        id = get_ad_box_id(ad_box)
        unless ad_ids.include? id
          ad_ids.push(get_ad_box_id(ad_box))
        end
      end
    end

    ad_ids
  end

  def date_matches_ad_box?(ad_box)
    pub_date_string = ad_box.css('.pub-date').children[1].text
    pub_date = Date.strptime(pub_date_string, '%d.%m.%Y')
    return pub_date == @date
  end

  def get_ad_box_id(ad_box)
    ad_box.css('.editFilter').children.find { |x| x.text.include? 'ID: ' }.text.remove_non_numbers.to_nil_or_i
  end
end
