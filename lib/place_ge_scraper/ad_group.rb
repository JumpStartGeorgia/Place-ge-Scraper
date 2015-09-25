require_relative '../../environment'

# Group of place.ge real estate ads
class PlaceGeAdGroup
  def initialize(start_date, end_date, ad_limit)
    set_dates(start_date, end_date)
    @ad_limit = ad_limit

    scrape_ad_ids
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

  def dates_to_s
    if @start_date == @end_date
      "on #{@start_date}"
    else
      "between #{@start_date} and #{@end_date}"
    end
  end

  ########################################################################
  # Scrape ad ids #

  # The site displays VIP ads, then paid ads, then simple ads. So, the scraper
  # finds IDs of ads in the specified time period in the following manner:
  #
  # 1. Checks all VIP ads
  # 2. Checks all paid ads
  # 3. Checks simple ads. When a simple ad is found that does not match
  #    the date criteria, the scraper stops scraping IDs.
  def scrape_ad_ids
    ScraperLog.logger.info("\n---> Finding ids of ads posted #{dates_to_s}")
    puts "---> Number of ad limited to #{@ad_limit}" unless @ad_limit.nil?

    @finished_scraping_ids = false
    @found_simple_ad_box = false
    @ad_ids = []
    page_num = 1

    if @ad_limit.nil? || @ad_limit > 1000
      limit = 1000
    elsif @ad_limit < 100
      limit = 100
    else
      limit = @ad_limit
    end

    while not_finished_scraping_ids?
      link = "http://place.ge/ge/ads/page:#{page_num}?object_type=all&currency_id=2&mode=list&order_by=date&limit=#{limit}"
      scrape_ad_ids_from_page(link)
      page_num += 1
    end

    puts "\n--->Finished scraping ad ids; found #{@ad_ids.size} total ads\n"
    puts '--------------------------------------------------'
  end

  def scrape_ad_ids_from_page(link)
    puts '--------------------------------------------------'
    puts "-----> Scraping #{link}"
    page = Nokogiri.HTML(open(link))
    ad_boxes = page.css('.tr-line')

    ad_boxes.each do |ad_box_html|
      process_ad_box(PlaceGeAdBox.new(ad_box_html))

      # If finished, don't scrape the rest of the ad boxes
      break if finished_scraping_ids?
    end

    puts "\n-----> Found #{@ad_ids.size} ads posted #{dates_to_s} so far"
  end

  def process_ad_box(ad_box)
    if ad_box.between_dates?(@start_date, @end_date)
      # Save ad id if it has not been saved to @ad_ids yet
      unless @ad_ids.include?(ad_box.id)
        @ad_ids.push(ad_box.id)
        puts "-------> Found #{ad_box.id} (posted on #{ad_box.pub_date})"
      end

      # Simple ads are listed in reverse chronological order. Therefore, if
      # the ad group has an end date before today, the scraper should continue
      # until it finds at least one simple ad box that matches the desired time
      # period. Then, the scraper would stop when it finds a simple ad box
      # that does not match the time period (meaning that it is before the
      # start date).
      @found_simple_ad_box = true if not_found_simple_ad_box? && ad_box.simple?
    else
      # Stop scraping if the ad box is not between the dates, is simple, and
      # another simple ad box has been found
      @finished_scraping_ids = true if found_simple_ad_box? && ad_box.simple?
    end

    # If the number of desired ads is limited, and the number of ad ids
    # has reached that limit, stop scraping.
    @finished_scraping_ids = true if !@ad_limit.nil? && @ad_ids.size == @ad_limit
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
    puts "\n---> Scraping info of ads posted #{dates_to_s}"

    @ads = []
    @ad_errors = []

    @ad_ids.each { |ad_id| scrape_ad(ad_id) }
    puts "\n\n---> Finished scraping ads posted #{dates_to_s}!\n\n"

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

  ########################################################################
  # Save ads to database #

  def save_ads
    puts '--------------------------------------------------'
    puts '---> Saving ads to database'
    @ads.each { |ad| save_ad(ad) }
    puts "\n---> Finished saving ads to database"
  end

  def save_ad(ad)
    puts "\n-----> Saving ad ID #{ad.place_ge_id} to database\n\n"
    ad.save
  end
end
