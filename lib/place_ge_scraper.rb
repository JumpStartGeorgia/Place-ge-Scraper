require 'nokogiri'
require 'open-uri'

# Real estate ad on place.ge
class PlaceGeAd
  def scrape_price
    @page.css('.top-ad .price')[0].content[/\$.*\//].remove_non_numbers.to_i
  end

  def scrape_size
    @page.detail_value('Space').remove_non_numbers.to_i
  end

  def scrape_size_unit
    @page.detail_value('Space').remove_numbers.strip
  end

  def scrape_renovation_type
    @page.detail_value('Renovation')
  end

  def scrape_address
    @page.detail_value('Address')
  end

  def address_array
    @address.split(',').map(&:strip)
  end

  def get_city_from_address
    address_array[0]
  end

  def get_area_from_address
    address_array[1]
  end

  def get_district_from_address
    address_array[2]
  end

  def get_street_from_address
    address_array[3]
  end

  def scrape_building_number
    @page.detail_value('Building №')
  end

  def scrape_apartment_number
    @page.detail_value('Appartment No.')
  end

  def initialize(uri)
    @uri = uri
    @page = Nokogiri::HTML(open(@uri))

    @price = scrape_price
    @size = scrape_size
    @size_unit = scrape_size_unit

    @renovation_type = scrape_renovation_type
    @address = scrape_address
    @city = get_city_from_address
    @area = get_area_from_address
    @district = get_district_from_address
    @street = get_street_from_address
    @building_number = scrape_building_number
    @apartment_number = scrape_apartment_number
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{@uri}\n------------------------------------------------------\nPrice: #{@price}\nSize: #{@size} #{@size_unit}\nRenovation: #{@renovation_type}\n\nAddress: #{@address}\nCity: #{@city}\nArea: #{@area}\nDistrict: #{@district}\nStreet: #{@street}\nBuilding number: #{@building_number}\nApartment number: #{@apartment_number}"
  end
end

# Adds place.ge specific helper methods to String
class String
  def remove_non_numbers
    self.gsub!(/[^0-9]/, '')
  end

  def remove_numbers
    self.gsub!(/[0-9]/, '')
  end
end

# Adds place.ge specific helper methods to Nokogiri
class Nokogiri::XML::Node
  def detail_value(detail_label)
    self.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., '#{detail_label}')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
  end
end
