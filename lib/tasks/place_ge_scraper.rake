load 'lib/place_ge_scraper.rb'

desc 'Scrape place.ge real estate ad by id'
task :scrape_ad, [:place_ge_ad_id] do |_t, args|
  # Use default uri in case uri argument is not provided
  if args[:place_ge_ad_id].nil?
    puts 'Error: Please provide a place.ge ad ID as an argument.'
    return
  end

  ad = PlaceGeAd.new(args[:place_ge_ad_id])
  puts ad.to_s
end
