load 'lib/place_ge_scraper/ad_group.rb'

desc 'Scrape ads posted on place.ge today'
task :scrape_ads_posted_today do
  ad_group = PlaceGeAdGroup.new(Date.today, Date.today)
  ad_group.to_s
end

desc 'Scrape ads posted on place.ge yesterday'
task :scrape_ads_posted_yesterday do
  ad_group = PlaceGeAdGroup.new(Date.today - 1, Date.today - 1)
  ad_group.to_s
end

desc 'Scrape ads posted within provided time period; parameters should be in format yyyy-mm-dd, as in [2015-09-12,2015-09-14]'
task :scrape_ads_posted_in_time_period, [:start_date, :end_date] do |_t, args|
  if args[:start_date].nil?
    puts 'ERROR: Please provide a start date'
  elsif args[:end_date].nil?
    puts 'ERROR: Please provide an end date'
  end

  start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
  end_date = Date.strptime(args[:end_date], '%Y-%m-%d')

  ad_group = PlaceGeAdGroup.new(start_date, end_date)
  ad_group.to_s
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
