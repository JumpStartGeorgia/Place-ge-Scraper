require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require_relative 'ad'
require_relative 'helper'

# Group of place.ge real estate ads
class PlaceGeAdGroup
  def initialize
    @start_date = Date.today - 4
    @end_date = Date.today - 2

    @ad_boxes = scrape_ad_boxes
  end

  def to_s
    puts @ad_boxes.map { |ad_box| puts "#{ad_box.id} | #{ad_box.pub_date}" }
  end

  def scrape_ad_boxes
    page_num = 1
    limit = 10
    ad_boxes = []
    link = "http://place.ge/ge/ads/page:#{page_num}?object_type=all&currency_id=2&mode=list&order_by=date&limit=#{limit}"
    ad_boxes.push(*scrape_ad_boxes_from_page(link))
    ad_boxes
  end

  def scrape_ad_boxes_from_page(link)
    desired_ad_boxes = []

    page = Nokogiri.HTML(open(link))
    all_ad_boxes = page.css('.tr-line')

    all_ad_boxes.each do |ad_box_html|
      ad_box = PlaceGeAdBox.new(ad_box_html)
      desired_ad_boxes.push(ad_box) if ad_box.between_dates?(@start_date, @end_date)
    end

    desired_ad_boxes
  end
end

# Box containing ad info in place.ge ad list
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

  def vip?
    @is_vip = scrape_is_vip if @is_vip.nil?
    @is_vip
  end

  def paid?
    @is_paid = scrape_is_paid if @is_paid.nil?
    @is_paid
  end

  def simple?
    @is_simple = scrape_is_simple if @is_simple.nil?
    @is_simple
  end

  def between_dates?(start_date, end_date)
    (pub_date >= start_date) && (pub_date <= end_date)
  end
end
