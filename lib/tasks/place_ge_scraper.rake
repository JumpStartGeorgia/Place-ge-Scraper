namespace :place_ge_scraper do
  desc 'Scrape place.ge real estate ad by id'
  task :scrape_ad, [:place_ge_ad_id] => :environment do |_t, args|
    # Use default uri in case uri argument is not provided
    if args[:place_ge_ad_id].nil?
      puts 'Error: Please provide a place.ge ad ID as an argument.'
      return
    end

    require 'place_ge_scraper'
    ad = PlaceGeAd.new(args[:place_ge_ad_id])
    puts ad.to_s
  end
end
