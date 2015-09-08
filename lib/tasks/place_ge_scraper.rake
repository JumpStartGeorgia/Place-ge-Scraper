namespace :place_ge_scraper do
  desc 'Get price'
  task get_price: :environment do
    require 'place_ge_scraper'
    puts "Ad price: #{PlaceGeScraper.ad_price}"
  end

  task get_area: :environment do
    require 'place_ge_scraper'
    puts "Area square meters: #{PlaceGeScraper.area_square_meters}"    
  end
end
