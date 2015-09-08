require 'nokogiri'
require 'open-uri'

class PlaceGeAd
  def initialize(uri)
    @uri = uri
    @page = Nokogiri::HTML(open(@uri))
    @price = scrape_price
    @area = scrape_area
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{@uri}\n------------------------------------------------------\nPrice: #{@price}\nArea: #{@area}"
  end

  def scrape_price
    price_content = @page.css('.top-ad .price')[0].content
    price = price_content[/\$.*\//]
              .gsub("\t", '')
              .gsub('/', '')
              .gsub(',', '')
              .gsub('$', '')
              .to_i
  end

  def scrape_area
    area_whole_text = @page.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., 'Space')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
    area = area_whole_text.gsub!(/[^0-9]/, '').to_i
  end
end
