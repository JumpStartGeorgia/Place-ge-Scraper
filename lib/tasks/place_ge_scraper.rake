namespace :place_ge_scraper do
  desc 'Get price'
  task :scrape_ad, [:uri] => :environment do |_t, args|
    uri = args[:uri]
    require 'place_ge_scraper'

    ad = PlaceGeAd.new(uri)
    puts ad.to_s
  end
end
