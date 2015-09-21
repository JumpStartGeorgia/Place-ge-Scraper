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

    # scrape_ad_ids
    @ad_ids = [12345666, 773277342]
    scrape_ads
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

  ########################################################################
  # Scrape ad ids #

  def scrape_ad_ids
    if @start_date == @end_date
      puts "\n---> Finding ids of ads posted on #{@start_date}"
    else
      puts "\n---> Finding ids of ads posted between #{@start_date} and #{@end_date}"
    end

    @finished_scraping_ids = false
    @found_simple_ad_box = false
    @ad_ids = []
    page_num = 1
    limit = 1000

    while not_finished_scraping_ids?
      link = "http://place.ge/ge/ads/page:#{page_num}?object_type=all&currency_id=2&mode=list&order_by=date&limit=#{limit}"
      scrape_ad_ids_from_page(link)
      page_num += 1
    end

    puts "\n--->Finished scraping ad ids; found #{@ad_ids.size} ads\n"
    puts '--------------------------------------------------'
  end

  def scrape_ad_ids_from_page(link)
    puts '--------------------------------------------------'
    puts "-----> Scraping #{link}"
    page = Nokogiri.HTML(open(link))
    ad_boxes = page.css('.tr-line')

    ad_boxes.each do |ad_box_html|
      process_ad_box(PlaceGeAdBox.new(ad_box_html))

      if finished_scraping_ids?
        break
      end
    end

    if @start_date == @end_date
      puts "\n-----> Found #{@ad_ids.size} ads posted on #{@start_date} so far"
    else
      puts "\n-----> Found #{@ad_ids.size} ads posted between #{@start_date} and #{@end_date} so far"
    end
  end

  def process_ad_box(ad_box)
    if ad_box.between_dates?(@start_date, @end_date)
      # Save ad id if it has not been saved to @ad_ids yet
      unless @ad_ids.include?(ad_box.id)
        @ad_ids.push(ad_box.id)
        puts "-------> Found #{ad_box.id} (posted on #{ad_box.pub_date})"
      end

      # Record when the first simple ad is found to allow scraping to finish
      @found_simple_ad_box = true if not_found_simple_ad_box? && ad_box.simple?
    else
      # First must find simple ad, then stop when the next simple ad is found
      @finished_scraping_ids = true if found_simple_ad_box? && ad_box.simple?
    end
  end

  def finished_scraping_ids?
    @finished_scraping_ids
  end

  def not_finished_scraping_ids?
    !@finished_scraping_ids
  end

  def found_simple_ad_box?
    @found_simple_ad_box
  end

  def not_found_simple_ad_box?
    !@found_simple_ad_box
  end

  ########################################################################
  # Scraping full ad info #

  def scrape_ads
    if @start_date == @end_date
      puts "\n---> Scraping info of ads posted on #{@start_date}"
    else
      puts "\n---> Scraping info of ads posted between #{@start_date} and #{@end_date}"
    end

    @ads = []
    @ad_errors = []

    @ad_ids.each { |ad_id| scrape_ad(ad_id) }
    puts "\n\n---> Finished scraping ads!\n\n"

    display_ad_errors unless @ad_errors.empty?
  end

  def scrape_ad(ad_id)
    puts "\n-----> Scraping info for ad with id #{ad_id}"
    begin
      @ads.push(PlaceGeAd.new(ad_id))
    rescue StandardError => error
      puts "-------> ERROR! Ad ID #{ad_id} had following error while being scraped: #{error.inspect}"
      @ad_errors.push([ad_id, error])
    end
  end

  def display_ad_errors
    puts '--------------------------------------------------'
    puts "#{@ad_errors.size} ads had errors and could not be scraped:\n\n"
    @ad_errors.each_with_index do |ad_error, index|
      puts "#{index + 1}: AD ID #{ad_error[0]} Error - #{ad_error[1]}"
    end
  end
end
