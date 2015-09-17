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

    ad_boxes.each do |ad_box_html|
      ad_box = PlaceGeAdBox.new(ad_box_html)
      process_ad_box(ad_box, ad_ids)
    end

    ad_ids
  end

  def process_ad_box(ad_box, ad_ids)
    if ad_box.pub_date == @date
      unless ad_ids.include? ad_box.id
        ad_ids.push(ad_box.id)
      end
    end
  end
end

class PlaceGeAdBox
  def initialize(html)
    @html = html
  end

  def scrape_id
    @html.css('.editFilter').children.find { |x| x.text.include? 'ID: ' }.text.remove_non_numbers.to_nil_or_i
  end

  def scrape_pub_date
    pub_date_string = @html.css('.pub-date').children[1].text
    Date.strptime(pub_date_string, '%d.%m.%Y')
  end

  def id
    @id = scrape_id if @id.nil?
    @id
  end

  def pub_date
    @pub_date = scrape_pub_date if @pub_date.nil?
    @pub_date
  end
end
