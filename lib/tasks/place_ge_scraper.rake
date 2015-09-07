namespace :place_ge_scraper do
  desc 'Get price'
  task get_price: :environment do
    require 'place_ge_scraper'
    puts "Ad price: #{PlaceGeScraper.ad_price}"
  end
end
