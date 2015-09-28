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
      ScraperLog.logger.error 'The start date cannot be after the end date'
      fail
    elsif @start_date > Date.today
      ScraperLog.logger.error 'The start date cannot be after today'
      fail
    elsif @end_date > Date.today
      ScraperLog.logger.error 'The end date cannot be after today'
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
    ScraperLog.logger.info "Finding ids of ads posted #{dates_to_s}"
    ScraperLog.logger.info "Number of ad limited to #{@ad_limit}" unless @ad_limit.nil?

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

    ScraperLog.logger.info "Finished scraping ad ids; found #{@ad_ids.size} total ads"
  end

  def scrape_ad_ids_from_page(link)
    ScraperLog.logger.info "Retrieving #{link}"
    page = Nokogiri.HTML(open(link))
    ScraperLog.logger.info "Data retrieved from #{link}"

    ScraperLog.logger.info "Scraping #{link}"

    ad_boxes = page.css('.tr-line')

    ad_boxes.each do |ad_box_html|
      process_ad_box(PlaceGeAdBox.new(ad_box_html))

      # If finished, don't scrape the rest of the ad boxes
      break if finished_scraping_ids?
    end

    ScraperLog.logger.info "Found #{@ad_ids.size} ads posted #{dates_to_s} so far"
  end

  def process_ad_box(ad_box)
    if ad_box.between_dates?(@start_date, @end_date)
      # Save ad id if it has not been saved to @ad_ids yet
      unless @ad_ids.include?(ad_box.id)
        @ad_ids.push(ad_box.id)
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
    ScraperLog.logger.info "Scraping info of ads posted #{dates_to_s}"

    @ads = []
    @ad_scrape_errors = []

    @ad_ids.each_with_index do |ad_id, index|
      scrape_ad(ad_id)
      remaining_ads_to_scrape = @ad_ids.size - (index + 1)
      if remaining_ads_to_scrape % 20 == 0
        ScraperLog.logger.info "#{remaining_ads_to_scrape} ads remaining to be scraped"
      end
    end
    ScraperLog.logger.info "Finished scraping ads posted #{dates_to_s}!"
  end

  def scrape_ad(ad_id)
    ScraperLog.logger.info "Scraping info for ad with id #{ad_id}"
    begin
      @ads.push(PlaceGeAd.new(ad_id))
    rescue StandardError => error
      ScraperLog.logger.error "Ad ID #{ad_id} had following error while being scraped: #{error.inspect}"
      @ad_scrape_errors.push([ad_id, error])
    end
  end

  ########################################################################
  # Save ads to database #

  def save_ads
    @ad_save_errors = []

    ScraperLog.logger.info 'Saving ads to database'
    @ads.each { |ad| save_ad(ad) }
    ScraperLog.logger.info 'Finished saving ads to database'
  end

  def save_ad(ad)
    ScraperLog.logger.info "Saving ad ID #{ad.place_ge_id} to database"
    begin
      ad.save
    rescue StandardError => error
      ScraperLog.logger.error "Ad ID #{ad.place_ge_id} had following error while being saved: #{error.inspect}"
      @ad_save_errors.push([ad.place_ge_id, error])
    end
  end

  ########################################################################
  # Display errors #

  def email_errors
    return if @ad_save_errors.empty? && @ad_scrape_errors.empty?

    # Send email with attachment.
    error_mail = Mail.new do
      from     ENV['GMAIL_USER']
      to       'nathan.shane@jumpstart.ge'
      subject  'Place.Ge Scraper Errors'
      body     'LOTS OF ERRORS!!!!'
    end

    # Don't forget delivery
    error_mail.deliver!
  end

  def display_errors
    display_ad_scrape_errors unless @ad_scrape_errors.empty?
    display_ad_save_errors unless @ad_save_errors.empty?
  end

  def display_ad_scrape_errors
    ScraperLog.logger.info "#{@ad_scrape_errors.size} ads could not be scraped due to errors:"
    @ad_scrape_errors.each_with_index do |ad_error, index|
      ScraperLog.logger.info "#{index + 1}: AD ID #{ad_error[0]} Error - #{ad_error[1].inspect}"
    end
  end

  def display_ad_save_errors
    ScraperLog.logger.info "#{@ad_save_errors.size} ads could not be saved to database due to errors:"
    @ad_save_errors.each_with_index do |ad_error, index|
      ScraperLog.logger.info "#{index + 1}: AD ID #{ad_error[0]} Error - #{ad_error[1].inspect}"
    end
  end
end
