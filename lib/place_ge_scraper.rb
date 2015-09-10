require 'nokogiri'
require 'open-uri'
require 'pry-byebug'

# Real estate ad on place.ge
class PlaceGeAd
  def scrape_price
    @page.css('.top-ad .price')[0].content[/\$.*\//].remove_non_numbers.to_i
  end

  def scrape_area
    @page.detail_value('Space').remove_non_numbers.to_i
  end

  def scrape_area_unit
    @page.detail_value('Space').remove_numbers.strip
  end

  def scrape_land_area
    @page.detail_value('Land').remove_non_numbers.to_i
  end

  def scrape_land_area_unit
    @page.detail_value('Land').remove_numbers.strip
  end

  def scrape_room_count
    @page.detail_value('Rooms').remove_non_numbers.to_i
  end

  def scrape_condition
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

  def get_region_from_address
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

  def scrape_all
    @price = scrape_price
    @area = scrape_area
    @area_unit = scrape_area_unit
    @land_area = scrape_land_area
    @land_area_unit = scrape_land_area_unit

    @room_count = scrape_room_count
    @condition = scrape_condition
    @address = scrape_address
    @city = get_city_from_address
    @region = get_region_from_address
    @district = get_district_from_address
    @street = get_street_from_address
    @building_number = scrape_building_number
    @apartment_number = scrape_apartment_number
  end

  def initialize(place_ge_ad_id)
    @place_ge_id = place_ge_ad_id
    @link = "http://place.ge/en/ads/view/#{@place_ge_id}"
    @page = Nokogiri::HTML(open(@link))

    scrape_all
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{@uri}\n------------------------------------------------------\nPrice: #{@price}\nSize: #{@size}\nSize unit: #{@size_unit}\nRenovation: #{@renovation_type}\n\nAddress: #{@address}\nCity: #{@city}\nArea: #{@area}\nDistrict: #{@district}\nStreet: #{@street}\nBuilding number: #{@building_number}\nApartment number: #{@apartment_number}"
  end

  def place_ge_id
    @place_ge_id
  end

  def link
    @link
  end

  def publication_date
    @publication_date
  end

  def deal_type
    @deal_type
  end

  def property_type
    @property_type
  end

  def city_id
    @city_id
  end

  def city
    @city
  end

  def region_id
    @region_id
  end

  def region
    @region
  end

  def district_id
    @district_id
  end

  def district
    @district
  end

  def street_id
    @street_id
  end

  def street
    @street
  end

  def price
    @price
  end

  def price_per_area_unit
    @price_per_area_unit
  end

  def price_currency
    @price_currency
  end

  def area
    @area
  end

  def area_unit
    @area_unit
  end

  def land_area
    @land_area
  end

  def land_area_unit
    @land_area_unit
  end

  def distance_from_tbilisi
    @distance_from_tbilisi
  end

  def distance_from_main_road
    @distance_from_main_road
  end

  def condition
    @condition
  end

  def project
    @project
  end

  def status
    @status
  end

  def array
    @array
  end

  def quarter
    @quarter
  end

  def neighborhood
    @neighborhood
  end

  def building_number
    @building_number
  end

  def apartment_number
    @apartment_number
  end

  def address
    @address
  end

  def floor_number
    @floor_number
  end

  def total_floor_count
    @total_floor_count
  end

  def room_count
    @room_count
  end

  def bathroom_count
    @bathroom_count
  end

  def bedroom_count
    @bedroom_count
  end

  def balcony_count
    @balcony_count
  end

  def is_bank_real_estate
    @is_bank_real_estate
  end

  def has_garage_or_parking
    @has_garage_or_parking
  end

  def has_lift
    @has_lift
  end

  def has_furniture
    @has_furniture
  end

  def has_fireplace
    @has_fireplace
  end

  def has_storage_area
    @has_storage_area
  end

  def has_wardrobe
    @has_wardrobe
  end

  def has_air_conditioner
    @has_air_conditioner
  end

  def has_heating
    @has_heating
  end

  def has_loggia
    @has_loggia
  end

  def has_technology
    @has_technology
  end

  def has_hot_water
    @has_hot_water
  end

  def has_tv
    @has_tv
  end

  def has_phone
    @has_phone
  end

  def has_internet
    @has_internet
  end

  def has_alarm
    @has_alarm
  end

  def has_doorphone
    @has_doorphone
  end

  def has_security
    @has_security
  end

  def has_conference_hall
    @has_conference_hall
  end

  def has_showcase
    @has_showcase
  end

  def has_veranda
    @has_veranda
  end

  def is_mansard
    @is_mansard
  end

  def has_electricity
    @has_electricity
  end

  def has_gas
    @has_gas
  end

  def has_water
    @has_water
  end

  def has_sewage
    @has_sewage
  end

  def has_inventory
    @has_inventory
  end

  def has_network
    @has_network
  end

  def has_generator
    @has_generator
  end

  def additional_information
    @additional_information
  end

  def telephone_number
    @telephone_number
  end
end

# Adds place.ge specific helper methods to String
class String
  def remove_non_numbers
    gsub(/[^0-9]/, '')
  end

  def remove_numbers
    gsub(/[0-9]/, '')
  end
end

# Adds place.ge specific helper methods to Nokogiri
class Nokogiri::XML::Node
  def detail_value(detail_label)
    self.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., '#{detail_label}')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
  end
end
