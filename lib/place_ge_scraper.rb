require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'pry-byebug'

# Real estate ad on place.ge
class PlaceGeAd
  def initialize(place_ge_ad_id)
    @place_ge_id = place_ge_ad_id
    @link = "http://place.ge/en/ads/view/#{place_ge_id}"
    @time_of_scrape = Time.now

    # Saves copies of scraped ad html in <project_dir>/place_ge_ads_html/
    FileUtils.mkdir_p 'place_ge_ads_html'
    open(ad_source_file_path, 'wb') do |file|
      open(@link) do |uri|
        ad_source = uri.read
        file.write(ad_source)

        @html_copy_path = File.expand_path(ad_source_file_path)
        @page = Nokogiri::HTML(ad_source)
      end
    end

    scrape_all
  end

  def ad_source_file_path
    "place_ge_ads_html/place_ge_ad_#{place_ge_id}_time_#{time_of_scrape.strftime('%Y_%m_%d_%H_%M_%S')}.html"
  end
  private :ad_source_file_path

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{link}\n------------------------------------------------------\nPlace.Ge ID: #{place_ge_id}\nTime of Scrape: #{time_of_scrape}\nPath to HTML Copy: #{html_copy_path}\nPublication Date: #{publication_date}\nDeal type: #{deal_type}\nProperty type: #{property_type}\nCity ID: #{city_id}\nCity: #{city}\nRegion ID: #{region_id}\nRegion: #{region}\nDistrict ID: #{district_id}\nDistrict: #{district}\nStreet ID: #{street_id}\nStreet: #{street}\nPrice: #{price}\nPrice per area unit: #{price_per_area_unit}\nPrice currency: #{price_currency}\nPrice timeframe: #{price_timeframe}\nArea: #{area}\nArea unit: #{area_unit}\nLand area: #{land_area}\nLand area unit: #{land_area_unit}\nDistance from Tbilisi: #{distance_from_tbilisi}\nDistance from main road: #{distance_from_main_road}\nFunction: #{function}\nCondition: #{condition}\nProject: #{project}\nStatus: #{status}\nArray: #{array}\nQuarter: #{quarter}\nNeighborhood: #{neighborhood}\nBuilding number: #{building_number}\nApartment number: #{apartment_number}\nAddress: #{address}\nFloor number: #{floor_number}\nTotal floor count: #{total_floor_count}\nRoom count: #{room_count}\nBathroom count: #{bathroom_count}\nBedroom count: #{bedroom_count}\nBalcony count: #{balcony_count}\nIs bank real estate: #{is_bank_real_estate}\nHas garage or parking: #{has_garage_or_parking}\nHas lift: #{has_lift}\nHas furniture: #{has_furniture}\nHas fireplace: #{has_fireplace}\nHas storage area: #{has_storage_area}\nHas wardrobe: #{has_wardrobe}\nHas air conditioning: #{has_air_conditioning}\nHas heating: #{has_heating}\nHas loggia: #{has_loggia}\nHas appliances: #{has_appliances}\nHas hot water: #{has_hot_water}\nHas TV: #{has_tv}\nHas phone: #{has_phone}\nHas internet: #{has_internet}\nHas alarm: #{has_alarm}\nHas doorphone: #{has_doorphone}\nHas security: #{has_security}\nHas conference hall: #{has_conference_hall}\nHas showcase: #{has_showcase}\nHas veranda: #{has_veranda}\nIs mansard: #{is_mansard}\nHas electricity: #{has_electricity}\nHas gas: #{has_gas}\nHas water supply: #{has_water_supply}\nHas sewage: #{has_sewage}\nHas inventory: #{has_inventory}\nHas network: #{has_network}\nHas generator: #{has_generator}\nAdditional information: #{additional_information}\nTelephone number: #{telephone_number}\nSeller type: #{seller_type}\nSeller name: #{seller_name}"
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

    @function = scrape_function
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

  def set_field_from_param(param, link_text)
    param_name = param.slice(0, param.index('='))
    param_value = param.slice(param.index('=') + 1, param.size)

    case param_name
    when 'type'
      @deal_type = param_value.to_nil_if_empty
    when 'object_type'
      @property_type = param_value.to_nil_if_empty
    when 'city_id'
      @city_id = param_value.to_nil_or_i
      @city = link_text.to_nil_if_empty
    when 'region_id'
      @region_id = param_value.to_nil_or_i
      @region = link_text.to_nil_if_empty
    when 'district_id'
      @district_id = param_value.to_nil_or_i
      @district = link_text.to_nil_if_empty
    when 'street_id'
      @street_id = param_value.to_nil_or_i
      @street = link_text.to_nil_if_empty
    end
  end

  def scrape_breadcrums_info
    breadcrums = @page.css('div.breadcrums a')
    breadcrums.delete(breadcrums[0]) # Remove Home link

    breadcrums.each do |breadcrum|
      link = breadcrum.attributes['href'].value
      unless link.include? '&'
        param = link.slice(link.index('?') + 1, link.size)
        set_field_from_param(param, breadcrum.text)
      else
        last_ampersand_index = link.enum_for(:scan, /&/).map { Regexp.last_match.begin(0) }.last
        param = link.slice(last_ampersand_index + 1, link.size)
        set_field_from_param(param, breadcrum.text)
      end
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
    when 'lari'
      @price_currency = 'lari'
    end
  end

  def scrape_price_info
    price_info = @page.css('.top-ad .price').children

    # If the only price info is the text 'Contract price'
    if price_info.text.include? 'Contract price'
      @price = 'Contract price'
      @price_per_area_unit = nil
      @price_timeframe = nil
      @price_currency = nil
    else
      # If 'urgently' markup is next to price, remove it
      if price_info[1].text == 'urgently'
        price_info.delete(price_info[0])
        price_info.delete(price_info[0])
      end

      @price_per_area_unit = price_info[1].text.remove_non_numbers.to_nil_if_empty

      full_price = price_info[0].text.strip

      # If it contains a /, that means the price has a timeframe.
      # Example: '50 lari / day' (as opposed to just '50 lari')
      if full_price.include? '/'
        full_price_index = full_price.index('/')
        price_and_currency = full_price.slice(0, full_price_index)
        @price_timeframe = full_price.slice(full_price_index + 1, full_price.size).strip
      else
        price_and_currency = full_price
      end

      @price = price_and_currency.remove_non_numbers.to_nil_if_empty
      currency = price_and_currency.remove_numbers.sub(',', '').strip
      set_price_currency(currency)
    end
  end

  def scrape_area
    @page.detail_value('Space').remove_non_numbers.to_nil_if_empty
  end

  def scrape_area_unit
    @page.detail_value('Space').remove_numbers.strip.to_nil_if_empty
  end

  def scrape_land_area
    @page.detail_value('Land').remove_non_numbers.to_nil_if_empty
  end

  def scrape_land_area_unit
    @page.detail_value('Land').remove_numbers.strip.to_nil_if_empty
  end

  def scrape_room_count
    @page.detail_value('Rooms').remove_non_numbers.to_nil_if_empty
  end

  def scrape_bathroom_count
    @page.detail_value('Bathrooms').remove_non_numbers.to_nil_if_empty
  end

  def scrape_bedroom_count
    @page.detail_value('Bedrooms').remove_non_numbers.to_nil_if_empty
  end

  def scrape_balcony_count
    @page.detail_value('Balcony').remove_non_numbers.to_nil_if_empty
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

      @floor_number = floor_data[0].to_nil_if_empty
      @total_floor_count = floor_data[1].to_nil_if_empty
    else
      @floor_number = nil
      @total_floor_count = floor_string.to_nil_if_empty
    end
  end

  def scrape_function
    @page.detail_value('Function').to_nil_if_empty
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
    @page.detail_value('Building №').to_nil_if_empty
  end

  def scrape_apartment_number
    @page.detail_value('Appartment No.').to_nil_if_empty
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
    @has_electricity = @features.include? 'Electricity'
    @has_gas = @features.include? 'Gas'
    @has_water_supply = @features.include? 'Water supply'
    @has_sewage = nil
    @has_inventory = nil
    @has_network = nil
    @has_generator = nil
  end

  def scrape_additional_information
    @page
      .css('.contentInfo')
      .text
      .gsub(/.*Additional information:/m, '')
      .gsub(/\r\n/, ' ')
      .squeeze(" ")
      .strip
      .to_nil_if_empty
  end

  def scrape_telephone_number
    telephone_container = @page.css('.item.call')

    telephone_container
      .search('.//div')
      .remove
      .search('.//span')
      .remove

    telephone_container.text.strip.to_nil_if_empty
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

  def time_of_scrape
    @time_of_scrape
  end

  def html_copy_path
    @html_copy_path
  end

  def page
    @page
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

  def price_timeframe
    @price_timeframe
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
    # @distance_from_tbilisi
    'Not scraping'
  end

  def distance_from_main_road
    # @distance_from_main_road
    'Not scraping'
  end

  def function
    @function
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
    # @array
    'Not scraping'
  end

  def quarter
    # @quarter
    'Not scraping'
  end

  def neighborhood
    # @neighborhood
    'Not scraping'
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
    # @has_conference_hall
    'Not scraping'
  end

  def has_showcase
    # @has_showcase
    'Not scraping'
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

  def has_water_supply
    @has_water_supply
  end

  def has_sewage
    # @has_sewage
    'Not scraping'
  end

  def has_inventory
    # @has_inventory
    'Not scraping'
  end

  def has_network
    # @has_network
    'Not scraping'
  end

  def has_generator
    # @has_generator
    'Not scraping'
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
