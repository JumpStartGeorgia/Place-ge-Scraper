require_relative '../../environment'

namespace :scraper do
  desc 'Scrape ads posted on place.ge today'
  task :scrape_ads_posted_today, [:limit] do |_t, args|
    limit = clean_limit(args[:limit])
    ad_group = PlaceGeAdGroup.new(Date.today, Date.today, limit)
    ad_group.save_ads
  end

  desc 'Scrape ads posted on place.ge yesterday'
  task :scrape_ads_posted_yesterday, [:limit] do |_t, args|
    limit = clean_limit(args[:limit])
    ad_group = PlaceGeAdGroup.new(Date.today - 1, Date.today - 1, limit)
    ad_group.save_ads
  end

  desc 'Scrape ads posted within provided time period; parameters should be in format yyyy-mm-dd, as in [2015-09-12,2015-09-14]'
  task :scrape_ads_posted_in_time_period, [:start_date, :end_date, :limit] do |_t, args|
    if args[:start_date].nil?
      puts 'ERROR: Please provide a start date'
    elsif args[:end_date].nil?
      puts 'ERROR: Please provide an end date'
    end

    start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
    end_date = Date.strptime(args[:end_date], '%Y-%m-%d')
    limit = clean_limit(args[:limit])

    ad_group = PlaceGeAdGroup.new(start_date, end_date, limit)
    ad_group.save_ads
  end

  desc 'Scrape place.ge real estate ad by id'
  task :scrape_ad, [:place_ge_ad_id] do |_t, args|
    if args[:place_ge_ad_id].nil?
      puts 'Error: Please provide a place.ge ad ID as an argument.'
      return
    end

    ad = PlaceGeAd.new(args[:place_ge_ad_id])
    puts ad.to_s
  end

  desc 'Open place.ge real estate ad in default browser'
  task :open_ad_in_browser, [:place_ge_ad_id] do |_t, args|
    if args[:place_ge_ad_id].nil?
      puts 'Error: Please provide a place.ge ad ID as an argument.'
      return
    end

    ad = PlaceGeAd.new(args[:place_ge_ad_id])
    ad.open_in_browser
  end

  def clean_limit(unclean_limit)
    return nil if unclean_limit.nil?
    return nil unless unclean_limit =~ /[[:digit:]]/
    return unclean_limit.to_i
  end
end
