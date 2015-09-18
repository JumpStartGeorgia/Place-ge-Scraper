require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require_relative 'ad'
require_relative 'ad_box'
require_relative 'helper'

# Group of place.ge real estate ads
class PlaceGeAdGroup
  def initialize(start_date, end_date)
    set_dates(start_date, end_date)

    @finished_scraping = false
    @found_simple_ad = false

    scrape_ad_ids
  end

  def set_dates(start_date, end_date)
    @start_date = start_date
    @end_date = end_date

    check_dates_are_valid
  end

  def check_dates_are_valid
    if @start_date > @end_date
      puts "\nERROR: The start date cannot be after the end date\n\n"
      fail
    elsif @start_date > Date.today
      puts "\nERROR: The start date cannot be after today\n\n"
      fail
    elsif @end_date > Date.today
      puts "\nERROR: The end date cannot be after today\n\n"
      fail
    end
  end

  def to_s
    "Found #{@ad_ids.size} ads posted between #{@start_date} and #{@end_date}"
  end

  def scrape_ad_ids
    puts "\n---> Finding ids of ads posted between #{@start_date} and #{@end_date}"

    @ad_ids = []
    page_num = 1
    limit = 1000

    while not_finished_scraping?
      link = "http://place.ge/ge/ads/page:#{page_num}?object_type=all&currency_id=2&mode=list&order_by=date&limit=#{limit}"
      scrape_ad_ids_from_page(link)
      page_num += 1
    end

    puts "\nFinished scraping ad ids; found #{@ad_ids.size} ads\n"
    puts '--------------------------------------------------'
  end

  def scrape_ad_ids_from_page(link)
    puts '--------------------------------------------------'
    puts "-----> Scraping #{link}"
    page = Nokogiri.HTML(open(link))
    ad_boxes = page.css('.tr-line')

    ad_boxes.each do |ad_box_html|
      process_ad_box(PlaceGeAdBox.new(ad_box_html))

      if finished_scraping?
        break
      end
    end

    puts "\n-----> Found #{@ad_ids.size} ads posted between #{@start_date} and #{@end_date} so far"
  end

  def process_ad_box(ad_box)
    if ad_box.between_dates?(@start_date, @end_date)
      # Save ad id if it has not been saved to @ad_ids yet
      unless @ad_ids.include?(ad_box.id)
        @ad_ids.push(ad_box.id)
        puts "-------> Found #{ad_box.id} (posted on #{ad_box.pub_date})"
      end

      # Record when the first simple ad is found to allow scraping to finish
      @found_simple_ad = true if not_found_simple_ad? && ad_box.simple?
    else
      # First must find simple ad, then stop when the next simple ad is found
      @finished_scraping = true if found_simple_ad? && ad_box.simple?
    end
  end

  def finished_scraping?
    @finished_scraping
  end

  def not_finished_scraping?
    !@finished_scraping
  end

  def found_simple_ad?
    @found_simple_ad
  end

  def not_found_simple_ad?
    !@found_simple_ad
  end
end
