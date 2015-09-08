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

  def self.area_square_meters
    page = Nokogiri::HTML(open("http://place.ge/en/ads/view/459002"))
    area_whole_text = page.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., 'Space')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
    area = area_whole_text.gsub!(/[^0-9]/, '').to_i
  end
end
