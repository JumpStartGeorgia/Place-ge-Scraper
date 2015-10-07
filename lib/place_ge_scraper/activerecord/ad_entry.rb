require_relative '../../../environment'

# An ActiveRecord class for saving data in a place.ge ad entry in a database
class AdEntry < ActiveRecord::Base
  belongs_to :ad

  # Combines price, price_currency and price_timeframe
  def full_price
    return price if price.nil?
    currency = price_currency == 'dollar' ? 'dollars' : price_currency

    if price_timeframe.nil?
      "#{price} #{currency}"
    else
      "#{price} #{currency}/#{price_timeframe}"
    end
  end

  # Gets all attributes except for id and time of scrape, which are unrelated
  # to the actual info on place.ge
  def place_ge_entry_attributes
    attributes.except('id').except('time_of_scrape')
  end

  def same_entry?(second_entry)
    place_ge_entry_attributes == second_entry.place_ge_entry_attributes
  end

  def self.published_on_or_after(start_date)
    where('publication_date >= ?', start_date)
  end

  def self.published_on_or_before(end_date)
    where('publication_date <= ?', end_date)
  end

  def self.most_recent_entry_for_each_ad
  end

  def entries_of_same_ad
    AdEntry.where(ad_id: ad_id)
  end

  def should_save?
    entries_of_same_ad.each do |entry_of_same_ad|
      if same_entry?(entry_of_same_ad)
        entry_of_same_ad.update_column(:time_of_scrape, time_of_scrape)
        return false
      end
    end

    true
  end

  def self.build(place_ge_ad_info, ad_id)
    new(
      ad_id: ad_id,
      additional_information: place_ge_ad_info.additional_information,
      address: place_ge_ad_info.address,
      apartment_number: place_ge_ad_info.apartment_number,
      area: place_ge_ad_info.area,
      area_unit: place_ge_ad_info.area_unit,
      balcony_count: place_ge_ad_info.balcony_count,
      bathroom_count: place_ge_ad_info.bathroom_count,
      bedroom_count: place_ge_ad_info.bedroom_count,
      building_number: place_ge_ad_info.building_number,
      city: place_ge_ad_info.city,
      city_id: place_ge_ad_info.city_id,
      condition: place_ge_ad_info.condition,
      deal_type: place_ge_ad_info.deal_type,
      distance_from_main_road: place_ge_ad_info.distance_from_main_road,
      distance_from_tbilisi: place_ge_ad_info.distance_from_tbilisi,
      district: place_ge_ad_info.district,
      district_id: place_ge_ad_info.district_id,
      features: place_ge_ad_info.features,
      floor_number: place_ge_ad_info.floor_number,
      function: place_ge_ad_info.function,
      has_air_conditioning: place_ge_ad_info.has_air_conditioning,
      has_alarm: place_ge_ad_info.has_alarm,
      has_appliances: place_ge_ad_info.has_appliances,
      has_conference_hall: place_ge_ad_info.has_conference_hall,
      has_doorphone: place_ge_ad_info.has_doorphone,
      has_electricity: place_ge_ad_info.has_electricity,
      has_fireplace: place_ge_ad_info.has_fireplace,
      has_furniture: place_ge_ad_info.has_furniture,
      has_garage_or_parking: place_ge_ad_info.has_garage_or_parking,
      has_gas: place_ge_ad_info.has_gas,
      has_generator: place_ge_ad_info.has_generator,
      has_heating: place_ge_ad_info.has_heating,
      has_hot_water: place_ge_ad_info.has_hot_water,
      has_internet: place_ge_ad_info.has_internet,
      has_inventory: place_ge_ad_info.has_inventory,
      has_lift: place_ge_ad_info.has_lift,
      has_loggia: place_ge_ad_info.has_loggia,
      has_network: place_ge_ad_info.has_network,
      has_phone: place_ge_ad_info.has_phone,
      has_security: place_ge_ad_info.has_security,
      has_sewage: place_ge_ad_info.has_sewage,
      has_stained_glass_windows: place_ge_ad_info.has_stained_glass_windows,
      has_storage_area: place_ge_ad_info.has_storage_area,
      has_tv: place_ge_ad_info.has_tv,
      has_veranda: place_ge_ad_info.has_veranda,
      has_wardrobe: place_ge_ad_info.has_wardrobe,
      has_water_supply: place_ge_ad_info.has_water_supply,
      html_copy_path: place_ge_ad_info.html_copy_path,
      is_bank_real_estate: place_ge_ad_info.is_bank_real_estate,
      is_mansard: place_ge_ad_info.is_mansard,
      is_urgent: place_ge_ad_info.is_urgent,
      land_area: place_ge_ad_info.land_area,
      land_area_unit: place_ge_ad_info.land_area_unit,
      price: place_ge_ad_info.price,
      price_currency: place_ge_ad_info.price_currency,
      price_per_area_unit: place_ge_ad_info.price_per_area_unit,
      price_timeframe: place_ge_ad_info.price_timeframe,
      project: place_ge_ad_info.project,
      property_type: place_ge_ad_info.property_type,
      publication_date: place_ge_ad_info.publication_date,
      region: place_ge_ad_info.region,
      region_id: place_ge_ad_info.region_id,
      room_count: place_ge_ad_info.room_count,
      seller_name: place_ge_ad_info.seller_name,
      seller_type: place_ge_ad_info.seller_type,
      status: place_ge_ad_info.status,
      street: place_ge_ad_info.street,
      street_id: place_ge_ad_info.street_id,
      telephone_number: place_ge_ad_info.telephone_number,
      time_of_scrape: place_ge_ad_info.time_of_scrape,
      total_floor_count: place_ge_ad_info.total_floor_count
    )
  end
end
