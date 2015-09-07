require 'nokogiri'
require 'open-uri'

module PlaceGeScraper
  def self.ad_price
    page = Nokogiri::HTML(open("http://place.ge/en/ads/view/459002"))
    price_content = page.css('.top-ad .price')[0].content
    price = price_content[/\$.*\//]
              .gsub("\t", '')
              .gsub('/', '')
              .gsub(',', '')
              .gsub('$', '')
              .to_i
  end
end
