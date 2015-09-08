namespace :place_ge_scraper do
  desc 'Get price'
  task :scrape_ad, [:uri] => :environment do |_t, args|
    # Use default uri in case uri argument is not provided
    if args[:uri].present?
      uri = args[:uri]
    else
      uri = 'http://place.ge/en/ads/view/459002'
      puts "\nAd uri not provided; using default ad '#{uri}'"
      puts "To provide uri variable, run the task in this format:\n\nrake place_ge_scraper:scrape_ad['#{uri}']\n\n-------------\n"
    end

    require 'place_ge_scraper'
    ad = PlaceGeAd.new(uri)
    puts ad.to_s
  end
end
