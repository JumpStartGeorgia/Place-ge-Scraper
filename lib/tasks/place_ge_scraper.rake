require_relative '../../environment'

namespace :scraper do
  ########################################################################
  # Scrape ad ids, save as ads and mark them with has_unscraped_ad_entry #

  desc 'Scrape ads posted on place.ge today'
  task :scrape_ad_ids_posted_today, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted today'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today, Date.today, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  desc 'Scrape ads posted on place.ge yesterday'
  task :scrape_ad_ids_posted_yesterday, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted yesterday'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today - 1, Date.today - 1, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  desc 'Scrape ads posted within provided time period; parameters should be in format yyyy-mm-dd, as in [2015-09-12,2015-09-14]'
  task :scrape_ad_ids_posted_in_time_period, [:start_date, :end_date, :limit] do |_t, args|
    ScraperLog.logger.info "INVOKED TASK: Scraping ads posted between #{args[:start_date]} and #{args[:end_date]}"

    if args[:start_date].nil?
      ScraperLog.logger.error 'Please provide a start date'
    elsif args[:end_date].nil?
      ScraperLog.logger.error 'Please provide an end date'
    end

    start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
    end_date = Date.strptime(args[:end_date], '%Y-%m-%d')
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(start_date, end_date, limit)
      .run(&:scrape_and_save_unscraped_ad_entries)
  end

  ########################################################################
  # Scrape ads that are marked has_unscraped_ad_entry #

  desc 'Scrape ads posted on place.ge today'
  task :scrape_ad_ids_posted_today, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted today'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today, Date.today, limit)
      .run(&:scrape_and_save_unscraped_ad_entries)
  end

  desc 'Scrape ads posted on place.ge yesterday'
  task :scrape_ad_ids_posted_yesterday, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted yesterday'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today - 1, Date.today - 1, limit)
      .run(&:scrape_and_save_unscraped_ad_entries)
  end

  desc 'Scrape ads posted within provided time period; parameters should be in format yyyy-mm-dd, as in [2015-09-12,2015-09-14]'
  task :scrape_ad_ids_posted_in_time_period, [:start_date, :end_date, :limit] do |_t, args|
    ScraperLog.logger.info "INVOKED TASK: Scraping ads posted between #{args[:start_date]} and #{args[:end_date]}"

    if args[:start_date].nil?
      ScraperLog.logger.error 'Please provide a start date'
    elsif args[:end_date].nil?
      ScraperLog.logger.error 'Please provide an end date'
    end

    start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
    end_date = Date.strptime(args[:end_date], '%Y-%m-%d')
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(start_date, end_date, limit)
      .run(&:scrape_and_save_ad_ids)
  end

  ########################################################################
  # Single tasks #

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
  # Helpers #

  def clean_limit(unclean_limit)
    return nil if unclean_limit.nil?
    return nil unless unclean_limit =~ /[[:digit:]]/
    unclean_limit.to_i
  end
end
