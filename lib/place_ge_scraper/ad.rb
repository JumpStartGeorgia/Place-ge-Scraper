require_relative '../../environment'

# Real estate ad on place.ge
class PlaceGeAd
  def initialize(place_ge_ad_id)
    @place_ge_id = place_ge_ad_id
    @link = PlaceGeAd.link_for_id(place_ge_id)
    @time_of_scrape = Time.now.change(usec: 0).utc
  end

  # Saves copies of scraped ad html in <project_dir>/place_ge_ads_html/
  def retrieve_page_and_save_html_copy
    FileUtils.mkdir_p 'system/place_ge_ads_html'
    open(ad_source_file_path, 'wb') do |file|
      open(@link) do |uri|
        ad_source = uri.read
        file.write(ad_source)

        @html_copy_path = File.expand_path(ad_source_compressed_file_path)
        @page = Nokogiri::HTML(ad_source)
      end
    end
  end

  def ad_source_file_path
    "system/place_ge_ads_html/place_ge_ad_#{place_ge_id}_time_#{time_of_scrape.strftime('%Y_%m_%d_%H_%M_%S')}.html"
  end
  private :ad_source_file_path

  def ad_source_compressed_file_path
    "system/place_ge_ads_html/place_ge_ad_#{place_ge_id}_time_#{time_of_scrape.strftime('%Y_%m_%d_%H_%M_%S')}.html.tar.bz2"
  end
  private :ad_source_compressed_file_path

  def open_in_browser
    `open "#{link}"`
  end

  def to_s
    "\nScraping place.ge! Real Estate Ad Uri: #{link}\n------------------------------------------------------\nPlace.Ge ID: #{place_ge_id}\nTime of Scrape: #{time_of_scrape}\nPath to HTML Copy: #{html_copy_path}\nPublication Date: #{publication_date}\nDeal type: #{deal_type}\nProperty type: #{property_type}\nCity ID: #{city_id}\nCity: #{city}\nRegion ID: #{region_id}\nRegion: #{region}\nDistrict ID: #{district_id}\nDistrict: #{district}\nStreet ID: #{street_id}\nStreet: #{street}\nIs urgent: #{is_urgent}\nPrice: #{price}\nPrice per area unit: #{price_per_area_unit}\nPrice currency: #{price_currency}\nPrice timeframe: #{price_timeframe}\nArea: #{area}\nArea unit: #{area_unit}\nLand area: #{land_area}\nLand area unit: #{land_area_unit}\nDistance from Tbilisi: #{distance_from_tbilisi}\nDistance from main road: #{distance_from_main_road}\nFunction: #{function}\nCondition: #{condition}\nProject: #{project}\nStatus: #{status}\nBuilding number: #{building_number}\nApartment number: #{apartment_number}\nAddress: #{address}\nFloor number: #{floor_number}\nTotal floor count: #{total_floor_count}\nRoom count: #{room_count}\nBathroom count: #{bathroom_count}\nBedroom count: #{bedroom_count}\nBalcony count: #{balcony_count}\nIs bank real estate: #{is_bank_real_estate}\nHas garage or parking: #{has_garage_or_parking}\nHas lift: #{has_lift}\nHas furniture: #{has_furniture}\nHas fireplace: #{has_fireplace}\nHas storage area: #{has_storage_area}\nHas wardrobe: #{has_wardrobe}\nHas air conditioning: #{has_air_conditioning}\nHas heating: #{has_heating}\nHas loggia: #{has_loggia}\nHas appliances: #{has_appliances}\nHas hot water: #{has_hot_water}\nHas TV: #{has_tv}\nHas phone: #{has_phone}\nHas internet: #{has_internet}\nHas alarm: #{has_alarm}\nHas doorphone: #{has_doorphone}\nHas security: #{has_security}\nHas conference hall: #{has_conference_hall}\nHas veranda: #{has_veranda}\nIs mansard: #{is_mansard}\nHas electricity: #{has_electricity}\nHas gas: #{has_gas}\nHas water supply: #{has_water_supply}\nHas sewage: #{has_sewage}\nHas inventory: #{has_inventory}\nHas network: #{has_network}\nHas generator: #{has_generator}\nAdditional information: #{additional_information}\nTelephone number: #{telephone_number}\nSeller type: #{seller_type}\nSeller name: #{seller_name}"
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

    @distance_from_tbilisi = scrape_distance_from_tbilisi
    @distance_from_main_road = scrape_distance_from_main_road
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

  def set_breadcrum_field_defaults
    @deal_type = nil
    @property_type = nil
    @city_id = nil
    @city = nil
    @region_id = nil
    @region = nil
    @district_id = nil
    @district = nil
    @street_id = nil
    @street = nil
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
    set_breadcrum_field_defaults

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

    # Check if ad is urgent
    if price_info[1].nil?
      @is_urgent = false
    else
      @is_urgent = price_info[1].text == 'urgently'

      # If 'urgently' markup is next to price, remove it
      if @is_urgent
        price_info.delete(price_info[0])
        price_info.delete(price_info[0])
      end
    end

    # If there is no price listed
    if price_info[0].text.strip.empty? && price_info[1].nil?
      @price = nil
      @price_per_area_unit = nil
      @price_timeframe = nil
      @price_currency = nil
      return
    end
    # If the only price info is the text 'Contract price'
    if price_info.text.include? 'Contract price'
      @price = 'Contract price'
      @price_per_area_unit = nil
      @price_timeframe = nil
      @price_currency = nil

    # If there's an actual price
    else
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
      currency = price_and_currency.remove_numbers.gsub(',', '').strip
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
    detail = @page.detail_value('Land')
    numbers = detail.gsub(/[^0-9]*$/, '') # remove everything after numbers
    number_array = numbers.scan(/[0-9]+/).map(&:to_i)

    if number_array.count == 1
      number_array[0].to_s
    else
      ((number_array[0] + number_array[1])/2).to_s
    end
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

  def scrape_distance_from_tbilisi
    @page.detail_value('Distance from Tbilisi, km').to_nil_if_empty
  end

  def scrape_distance_from_main_road
    @page.detail_value('Distance from the main road, km').to_nil_if_empty
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

  def get_individual_features
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
    @has_conference_hall = @features.include? 'Conference hall'
    @has_stained_glass_windows = @features.include? 'Stained-glass windows'
    @has_veranda = @features.include? 'Porch'
    @is_mansard = @features.include? 'Mansard'
    @has_electricity = @features.include? 'Electricity'
    @has_gas = @features.include? 'Gas'
    @has_water_supply = @features.include? 'Water supply'
    @has_sewage = @features.include? 'Sewage'
    @has_inventory = @features.include? 'Implements'
    @has_network = @features.include? 'Network'
    @has_generator = @features.include? 'Generator'
  end

  def scrape_features
    pars_after_detail_box = @page.xpath("//div[contains(concat(' ', @class, ' '), ' detailBox22 ' )]/following-sibling::p")
    if pars_after_detail_box.empty? || pars_after_detail_box[0].text == 'View on the Map'
      @features = ''
    else
      @features = pars_after_detail_box[0].text
    end

    get_individual_features
    @features = nil if @features.empty?
  end

  def scrape_additional_information
    @page
      .css('.contentInfo')
      .text
      .gsub(/.*Additional information:/m, '')
      .gsub(/\r\n/, ' ')
      .squeeze(' ')
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
  attr_accessor :place_ge_id

  attr_accessor :link

  attr_accessor :time_of_scrape

  attr_accessor :html_copy_path

  attr_accessor :page

  attr_accessor :publication_date

  attr_accessor :deal_type

  attr_accessor :property_type

  attr_accessor :city_id

  attr_accessor :city

  attr_accessor :region_id

  attr_accessor :region

  attr_accessor :district_id

  attr_accessor :district

  attr_accessor :street_id

  attr_accessor :street

  attr_accessor :is_urgent

  attr_accessor :price

  attr_accessor :price_per_area_unit

  attr_accessor :price_currency

  attr_accessor :price_timeframe

  attr_accessor :area

  attr_accessor :area_unit

  attr_accessor :land_area

  attr_accessor :land_area_unit

  attr_accessor :distance_from_tbilisi

  attr_accessor :distance_from_main_road

  attr_accessor :function

  attr_accessor :condition

  attr_accessor :project

  attr_accessor :status

  # attr_accessor :array

  # attr_accessor :quarter

  # attr_accessor :neighborhood

  attr_accessor :building_number

  attr_accessor :apartment_number

  attr_accessor :address

  attr_accessor :floor_number

  attr_accessor :total_floor_count

  attr_accessor :room_count

  attr_accessor :bathroom_count

  attr_accessor :bedroom_count

  attr_accessor :balcony_count

  attr_accessor :features

  attr_accessor :is_bank_real_estate

  attr_accessor :has_garage_or_parking

  attr_accessor :has_lift

  attr_accessor :has_furniture

  attr_accessor :has_fireplace

  attr_accessor :has_storage_area

  attr_accessor :has_wardrobe

  attr_accessor :has_air_conditioning

  attr_accessor :has_heating

  attr_accessor :has_loggia

  attr_accessor :has_appliances

  attr_accessor :has_hot_water

  attr_accessor :has_tv

  attr_accessor :has_phone

  attr_accessor :has_internet

  attr_accessor :has_alarm

  attr_accessor :has_doorphone

  attr_accessor :has_security

  attr_accessor :has_conference_hall

  attr_accessor :has_stained_glass_windows

  attr_accessor :has_veranda

  attr_accessor :is_mansard

  attr_accessor :has_electricity

  attr_accessor :has_gas

  attr_accessor :has_water_supply

  attr_accessor :has_sewage

  attr_accessor :has_inventory

  attr_accessor :has_network

  attr_accessor :has_generator

  attr_accessor :additional_information

  attr_accessor :telephone_number

  attr_accessor :seller_type

  attr_accessor :seller_name

  ########################################################################
  # Class-level Helper Functions #

  def self.link_for_id(place_ge_id)
    "http://place.ge/en/ads/view/#{place_ge_id}"
  end

  ########################################################################
  # Save to database #

  def save
    # Look for place_ge_id in ads
    # If ad already exists with the same place_ge_id, save this info as a new ad_entry on that ad
    # If ad does not exist with the same place_ge_id, create a new ad with this place_ge_id and link, then a new ad_entry attached to that ad with the remaining info

    ad = Ad.find_or_create_by_place_ge_id(place_ge_id, link)
    new_ad_entry = AdEntry.build(self, ad.id)

    # Mark ad as no longer needing to be scraped
    ad.update_column(:has_unscraped_ad_entry, false)
    if new_ad_entry.should_save?
      new_ad_entry.save
      new_ad_entry
    else
      false
    end
  end
end
