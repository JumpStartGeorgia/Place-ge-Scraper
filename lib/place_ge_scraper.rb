require 'nokogiri'
require 'open-uri'
require 'pry-byebug'

# Real estate ad on place.ge
class PlaceGeAd
  def initialize(place_ge_ad_id)
    @place_ge_id = place_ge_ad_id
    @link = "http://place.ge/en/ads/view/#{@place_ge_id}"
    @page = Nokogiri::HTML(open(@link))

    scrape_all
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{@uri}\n------------------------------------------------------\nPrice: #{@price}\nSize: #{@size}\nSize unit: #{@size_unit}\nRenovation: #{@renovation_type}\n\nAddress: #{@address}\nCity: #{@city}\nArea: #{@area}\nDistrict: #{@district}\nStreet: #{@street}\nBuilding number: #{@building_number}\nApartment number: #{@apartment_number}"
  end

  ########################################################################
  ######################## Scrapers ######################################

  def scrape_all
    @publication_date = scrape_publication_date

    scrape_breadcrums_info
    scrape_price_info

    @area = scrape_area
    @area_unit = scrape_area_unit
    @land_area = scrape_land_area
    @land_area_unit = scrape_land_area_unit

    @room_count = scrape_room_count
    @bathroom_count = scrape_bathroom_count
    @bedroom_count = scrape_bedroom_count
    @balcony_count = scrape_balcony_count

    scrape_floor_info

    @condition = scrape_condition
    @status = scrape_status
    @project = scrape_project
    @address = scrape_address

    @building_number = scrape_building_number
    @apartment_number = scrape_apartment_number

    scrape_features

    @additional_information = scrape_additional_information
    @telephone_number = scrape_telephone_number

    scrape_seller_info
  end

  def scrape_breadcrums_info
    breadcrums = @page.css('div.breadcrums a')
    breadcrums.delete(breadcrums[0])
    breadcrums.each do |breadcrum|
      link = breadcrum.attributes['href'].value
      unless link.include? '&'
        param = link.slice(link.index('?') + 1, link.size)
        param_name = param.slice(0, param.index('='))
        param_value = param.slice(param.index('=') + 1, param.size)
        @deal_type = param_value
      end
      # last_ampersand_index = link.enum_for(:scan, /&/).map { Regexp.last_match.begin(0) }.last
    end
  end

  def scrape_publication_date
    date = @page.css('.titleRight').text.sub('added: ', '')
    Date.strptime(date, '%m/%d/%Y')
  end

  def set_price_currency(currency)
    case currency
    when '$'
      @price_currency = 'dollar'
    end
  end

  def scrape_price_info
    @price_info = @page.css('.top-ad .price').children

    # If 'urgently' markup is next to price, remove it
    if @price_info[1].text == 'urgently'
      @price_info.delete(@price_info[0])
      @price_info.delete(@price_info[0])
    end

    @full_price = @price_info[0].text.strip
    @price = @full_price.remove_non_numbers.to_nil_or_i
    @price_per_area_unit = @price_info[1].text.remove_non_numbers.to_nil_or_i
    set_price_currency(@full_price.strip.remove_numbers.sub(',', ''))
  end

  def scrape_area
    @page.detail_value('Space').remove_non_numbers.to_nil_or_i
  end

  def scrape_area_unit
    @page.detail_value('Space').remove_numbers.strip.to_nil_if_empty
  end

  def scrape_land_area
    @page.detail_value('Land').remove_non_numbers.to_nil_or_i
  end

  def scrape_land_area_unit
    @page.detail_value('Land').remove_numbers.strip.to_nil_if_empty
  end

  def scrape_room_count
    @page.detail_value('Rooms').remove_non_numbers.to_nil_or_i
  end

  def scrape_bathroom_count
    @page.detail_value('Bathrooms').remove_non_numbers.to_nil_or_i
  end

  def scrape_bedroom_count
    @page.detail_value('Bedrooms').remove_non_numbers.to_nil_or_i
  end

  def scrape_balcony_count
    @page.detail_value('Balcony').remove_non_numbers.to_nil_or_i
  end

  def scrape_floor_info
    floor_string = @page.detail_value('Floor').to_nil_if_empty

    # If the floor string contains a /, then the real estate is on one floor
    # in a building with multiple floors. @floor_number is the floor number,
    # and @total_floor_count is the number of floors in the building.
    #
    # If the floor string does not contain a /, then the real estate has
    # multiple floors. @total_floor_count is the number of floors in the
    # real estate.
    if floor_string.nil?
      @floor_number = nil
      @total_floor_count = nil
    elsif floor_string.include? '/'
      floor_data = floor_string.split('/')

      @floor_number = floor_data[0].to_nil_or_i
      @total_floor_count = floor_data[1].to_nil_or_i
    else
      @floor_number = nil
      @total_floor_count = floor_string.to_i
    end
  end

  def scrape_condition
    @page.detail_value('Renovation').to_nil_if_empty
  end

  def scrape_status
    @page.detail_value('Status').to_nil_if_empty
  end

  def scrape_project
    @page.detail_value('Project').to_nil_if_empty
  end

  def scrape_address
    @page.detail_value('Address').to_nil_if_empty
  end

  def scrape_building_number
    @page.detail_value('Building №').to_nil_or_i
  end

  def scrape_apartment_number
    @page.detail_value('Appartment No.').to_nil_or_i
  end

  def scrape_features
    @features = @page.xpath("//div[contains(concat(' ', @class, ' '), ' detailBox22 ' )]/following-sibling::p").text
    @is_bank_real_estate = @features.include? 'Banking Real Estate'
    @has_garage_or_parking = @features.include? 'Garage / Parking'
    @has_lift = @features.include? 'Elevator'
    @has_furniture = @features.include? 'Furniture'
    @has_fireplace = @features.include? 'Fireplace'
    @has_storage_area = @features.include? 'Storeroom'
    @has_wardrobe = @features.include? 'Dressing room'
    @has_air_conditioning = @features.include? 'Air conditioning'
    @has_heating = @features.include? 'Heating'
    @has_loggia = @features.include? 'Loggia'
    @has_appliances = @features.include? 'Appliances'
    @has_hot_water = @features.include? 'Hot water'
    @has_tv = @features.include? 'Television'
    @has_phone = @features.include? 'Telephone'
    @has_internet = @features.include? 'Internet'
    @has_alarm = @features.include? 'Alarm'
    @has_doorphone = @features.include? 'Doorphone'
    @has_security = @features.include? 'Guard'
    @has_conference_hall = nil
    @has_showcase = nil
    @has_veranda = @features.include? 'Porch'
    @is_mansard = @features.include? 'Mansard'
    @has_electricity = nil
    @has_gas = nil
    @has_water = nil
    @has_sewage = nil
    @has_inventory = nil
    @has_network = nil
    @has_generator = nil
  end

  def scrape_additional_information
    @page.css('.contentInfo').text.gsub(/.*Additional information:/m, '').strip.to_nil_if_empty
  end

  def scrape_telephone_number
    @page.css('.item.call').text.strip.split(' ')[0].to_nil_if_empty
  end

  def scrape_seller_info
    seller_data = @page.css('.group-agent .desc')
    seller_string = seller_data.text.strip
    if seller_data.empty?
      @seller_type = nil
      @seller_name = nil
    elsif seller_string == 'Banking Real Estate'
      @seller_type = 'Bank'
      @seller_name = nil
    else
      @seller_name = seller_data.css('a').text.to_nil_if_empty
      @seller_type = seller_string.sub(@seller_name, '').strip.to_nil_if_empty
    end
  end

  ########################################################################
  ######################## Field Getters #################################
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

  def has_air_conditioning
    @has_air_conditioning
  end

  def has_heating
    @has_heating
  end

  def has_loggia
    @has_loggia
  end

  def has_appliances
    @has_appliances
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

  def seller_type
    @seller_type
  end

  def seller_name
    @seller_name
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

  def to_nil_or_i
    empty? ? nil : to_i
  end

  def to_nil_if_empty
    if empty?
      return nil
    else
      return self
    end
  end
end

# Adds place.ge specific helper methods to Nokogiri
class Nokogiri::XML::Node
  def detail_value(detail_label)
    self.xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][contains(., '#{detail_label}')]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
  end
end
