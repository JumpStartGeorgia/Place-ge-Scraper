load 'lib/place_ge_scraper/ad_group.rb'

desc "Scrape multiple ads"
task :scrape_ads do
  ad_group = PlaceGeAdGroup.new

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
