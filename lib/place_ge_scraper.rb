require 'nokogiri'
require 'open-uri'

# Real estate ad on place.ge
class PlaceGeAd
  def scrape_price
    price_content = @page.css('.top-ad .price')[0].content
    price_content[/\$.*\//]
      .gsub("\t", '')
      .gsub('/', '')
      .gsub(',', '')
      .gsub('$', '')
      .to_i
  end

  def scrape_area
    area_whole_text = @page.detail_value('Space')
    area_whole_text.remove_non_numbers.to_i
  end

  def initialize(uri)
    @uri = uri
    @page = Nokogiri::HTML(open(@uri))

    @price = scrape_price
    @area = scrape_area
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{@uri}\n------------------------------------------------------\nPrice: #{@price}\nArea: #{@area}"
  end
end

# Adds place.ge specific helper methods to String
class String
  def remove_non_numbers
    self.gsub!(/[^0-9]/, '')
  end
end

# Adds place.ge specific helper methods to Nokogiri
class Nokogiri::XML::Node
  def detail_value(detail_label)
    self.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., '#{detail_label}')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
  end
end
