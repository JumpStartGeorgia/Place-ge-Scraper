require_relative '../../environment'

namespace :scraper do
  desc 'Scrape ads posted on place.ge today'
  task :scrape_ads_posted_today, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted today'
    limit = clean_limit(args[:limit])

    PlaceGeAdGroup.new(Date.today, Date.today, limit).run_scraper do |ad_group|
      ad_group.scrape_and_save_ad_ids
      ad_group.scrape_ads
      ad_group.save_ads
    end
  end

  desc 'Scrape ads posted on place.ge yesterday'
  task :scrape_ads_posted_yesterday, [:limit] do |_t, args|
    ScraperLog.logger.info 'INVOKED TASK: Scraping ads posted yesterday'
    limit = clean_limit(args[:limit])
    ad_group = PlaceGeAdGroup.new(Date.today - 1, Date.today - 1, limit)
    ad_group.scrape_and_save_ad_ids
    ad_group.scrape_ads
    ad_group.save_ads
    ad_group.log_errors
    ad_group.email_errors
  end

  desc 'Scrape ads posted within provided time period; parameters should be in format yyyy-mm-dd, as in [2015-09-12,2015-09-14]'
  task :scrape_ads_posted_in_time_period, [:start_date, :end_date, :limit] do |_t, args|
    ScraperLog.logger.info "INVOKED TASK: Scraping ads posted between #{args[:start_date]} and #{args[:end_date]}"

    if args[:start_date].nil?
      ScraperLog.logger.error 'Please provide a start date'
    elsif args[:end_date].nil?
      ScraperLog.logger.error 'Please provide an end date'
    end

    start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
    end_date = Date.strptime(args[:end_date], '%Y-%m-%d')
    limit = clean_limit(args[:limit])

    ad_group = PlaceGeAdGroup.new(start_date, end_date, limit)
    ad_group.scrape_and_save_ad_ids
    ad_group.scrape_ads
    ad_group.save_ads
    ad_group.log_errors
    ad_group.email_errors
  end

  desc 'Scrape place.ge real estate ad by id'
  task :scrape_ad, [:place_ge_ad_id] do |_t, args|
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

  def clean_limit(unclean_limit)
    return nil if unclean_limit.nil?
    return nil unless unclean_limit =~ /[[:digit:]]/
    unclean_limit.to_i
  end
end
