require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require_relative 'ad'
require_relative 'helper'

# Group of place.ge real estate ads
class PlaceGeAdGroup
  def initialize
    @start_date = Date.today - 7
    @end_date = Date.today

    @ad_ids = scrape_ad_ids
  end

  def to_s
    puts @ad_ids
  end

  def scrape_ad_ids
    link = "http://place.ge/ge/ads/page:1?object_type=all&currency_id=2&mode=list&order_by=date&limit=30"
    page = Nokogiri.HTML(open(link))

    ad_boxes = page.css('.tr-line')
    ad_ids = []

    ad_boxes.each do |ad_box_html|
      ad_box = PlaceGeAdBox.new(ad_box_html)
      puts 'VIP' if ad_box.is_vip?
      puts 'PAID' if ad_box.is_paid?
      puts 'SIMPLE' if ad_box.is_simple?
      process_ad_box(ad_box, ad_ids)
    end

    ad_ids
  end

  def process_ad_box(ad_box, ad_ids)
    return unless ad_box.pub_date == @date
    return if ad_ids.include? ad_box.id

    ad_ids.push(ad_box.id)
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

  def scrape_is_vip
    @html.attributes['class'].value.include? 'vip-ad'
  end

  def scrape_is_paid
    @html.attributes['class'].value.include? 'paid-ad'
  end

  def scrape_is_simple
    @html.attributes['class'].value.include? 'simple-ad'
  end

  def id
    @id = scrape_id if @id.nil?
    @id
  end

  def pub_date
    @pub_date = scrape_pub_date if @pub_date.nil?
    @pub_date
  end

  def is_vip?
    @is_vip = scrape_is_vip if @is_vip.nil?
    @is_vip
  end

  def is_paid?
    @is_paid = scrape_is_paid if @is_paid.nil?
    @is_paid
  end

  def is_simple?
    @is_simple = scrape_is_simple if @is_simple.nil?
    @is_simple
  end
end
