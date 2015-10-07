require_relative '../../environment'

namespace :scraper do
  ########################################################################
  # Scrape ad ids, save as ads and mark them with has_unscraped_ad_entry #

  desc 'Scrape ad ids posted on place.ge today and flag for scraping'
  task :scrape_ad_ids_posted_today, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: scrape_ad_ids_posted_today'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today, Date.today, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  desc 'Scrape ad ids posted on place.ge yesterday and flag for scraping'
  task :scrape_ad_ids_posted_yesterday, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: scrape_ad_ids_posted_yesterday'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today - 1, Date.today - 1, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  desc 'Scrape ad ids posted within provided time period and flag for scraping; parameters should be in format [yyyy-mm-dd,yyyy-mm-dd]'
  task :scrape_ad_ids_posted_in_time_period, [:start_date, :end_date, :limit] do |_t, args|
    ScraperLog.logger.info "INVOKED TASK: scrape_ad_ids_posted_in_time_period(#{args[:start_date]},#{args[:end_date]})"

    start_date = process_start_date(args[:start_date])
    end_date = process_end_date(args[:end_date])
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(start_date, end_date, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  ########################################################################
  # Scrape ads that are marked has_unscraped_ad_entry #

  desc 'Scrape ad entries for ads in database that are flagged for scraping'
  task :scrape_ads_flagged_unscraped do
    ScraperLog.logger.info 'INVOKED TASK: scrape_ads_flagged_unscraped'
    PlaceGeAdGroup.new.run(&:scrape_and_save_unscraped_ad_entries)
  end

  ########################################################################
  # Single ad tasks #

  desc 'Scrape place.ge real estate ad by id'
  task :scrape_and_output_ad, [:place_ge_ad_id] do |_t, args|
    if args[:place_ge_ad_id].nil?
      puts 'Error: Please provide a place.ge ad ID as an argument.'
      return
    end

    ad = PlaceGeAd.new(args[:place_ge_ad_id])
    ad.retrieve_page_and_save_html_copy
    ad.scrape_all
    puts ad.to_s
  end

  desc 'Open place.ge real estate ad in default browser'
  task :open_ad_in_browser, [:place_ge_ad_id] do |_t, args|
    if args[:place_ge_ad_id].nil?
      puts 'Please provide a place.ge ad ID as an argument.'
      return
    end

    ad = PlaceGeAd.new(args[:place_ge_ad_id])
    ad.open_in_browser
  end

  ########################################################################
  # CSV Export #

  desc 'Output subset of ad data to CSV for analysis by ISET; parameters should be in format [yyyy-mm-dd,yyyy-mm-dd]'
  task :export_ads_to_iset_csv, [:start_date, :end_date] do |_t, args|
    ScraperLog.logger.info "INVOKED TASK: export_ads_to_iset_csv(#{args[:start_date]},#{args[:end_date]})"

    start_date = process_start_date(args[:start_date])
    end_date = process_end_date(args[:end_date])

    Ad.to_iset_csv(start_date, end_date)
  end

  ########################################################################
  # Helpers #

  def clean_limit(unclean_limit)
    return nil if unclean_limit.nil?
    return nil unless unclean_limit =~ /[[:digit:]]/
    unclean_limit.to_i
  end

  def process_start_date(start_date)
    ScraperLog.logger.error 'Please provide a start date' if start_date.nil?
    begin
      Date.strptime(start_date, '%Y-%m-%d')
    rescue StandardError
      ScraperLog.logger.error 'Start date cannot be parsed'
      fail
    end
  end

  def process_end_date(end_date)
    ScraperLog.logger.error 'Please provide an end date' if end_date.nil?
    begin
      Date.strptime(end_date, '%Y-%m-%d')
    rescue StandardError
      ScraperLog.logger.error 'End date cannot be parsed'
      fail
    end
  end
end
