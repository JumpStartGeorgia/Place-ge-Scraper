require_relative '../../../environment'

# An ActiveRecord class for saving a place_ge_id and all the entries
# found with that id
class Ad < ActiveRecord::Base
  has_many :ad_entries

  def entry_not_found
    ScraperLog.logger.info "Entry for ad ##{place_ge_id} not found"

    if ad_entries.count == 0
      ScraperLog.logger
        .info "Destroying Ad ##{place_ge_id} because it has no ad entries"

      destroy
    else
      ScraperLog.logger
        .info "Setting has_unscraped_ad_entry for Ad ##{place_ge_id} to false"

      update_column(:has_unscraped_ad_entry, false)
    end
  end

  def self.with_unscraped_entry
    where(has_unscraped_ad_entry: true)
  end

  def self.find_or_create_by_place_ge_id(place_ge_id, link)
    ad = find_by_place_ge_id(place_ge_id)

    if ad.nil?
      ad = Ad.create(
        place_ge_id: place_ge_id,
        link: link,
        has_unscraped_ad_entry: false
      )
    end

    ad
  end

  def self.to_iset_csv(start_date, end_date, with_duplicates=true)
    ad_entries = AdEntry
                 .published_on_or_after(start_date)
                 .published_on_or_before(end_date)
                #  .most_recent_entry_for_each_ad

    # remove duplicate records if wanted
    ad_entries = ad_entries.is_primary_property if !with_duplicates


    if ad_entries.nil?
      ScraperLog.logger.info 'No ads to export in that time period'
      return
    end

    file_name = "Place.Ge Real Estate Data #{start_date} to #{end_date}.csv"

    require 'csv'
    CSV.open(file_name, 'wb') do |csv|
      csv << %w(pid price price_currency price_timeframe month year area larea type otype cid rid did tagged_sid renovation nrooms nbeds nbaths nbalcs wfloor status)

      ad_entries.each do |ad_entry|
        csv << [ad_entry.ad.place_ge_id, ad_entry.price, ad_entry.price_currency, ad_entry.price_timeframe, ad_entry.publication_date.month, ad_entry.publication_date.year, ad_entry.area, ad_entry.land_area, ad_entry.deal_type, ad_entry.property_type, ad_entry.city, ad_entry.region, ad_entry.district, ad_entry.street, ad_entry.condition, ad_entry.room_count, ad_entry.bedroom_count, ad_entry.bathroom_count, ad_entry.balcony_count, ad_entry.floor_number, ad_entry.status]
      end
    end

    ScraperLog.logger.info "Exported #{ad_entries.size} ads to #{file_name} for requested time period"
  end

  def self.to_csv(ids)
    ad_entries = AdEntry.where(id: ids)

    file_name = "place_ge_data.csv"

    require 'csv'
    CSV.open(file_name, 'wb') do |csv|
      csv << %w(place_ge_id ad_id additional_information address apartment_number area area_unit balcony_count bathroom_count bedroom_count building_number city city_id condition deal_type district district_id features floor_number function has_air_conditioning has_alarm has_appliances has_conference_hall has_doorphone has_electricity has_fireplace has_furniture has_garage_or_parking has_gas has_generator has_heating has_hot_water has_internet has_inventory has_lift has_loggia has_network has_phone has_security has_sewage has_storage_area has_tv has_veranda has_wardrobe has_water_supply html_copy_path is_bank_real_estate is_mansard is_urgent land_area land_area_unit price price_currency price_per_area_unit price_timeframe project property_type publication_date region region_id room_count seller_name seller_type status telephone_number time_of_scrape total_floor_count street street_id has_stained_glass_windows distance_from_main_road distance_from_tbilisi)

      ad_entries.each do |ad_entry|
        csv << [ad_entry.ad.place_ge_id,
                ad_entry.ad_id,
                ad_entry.additional_information,
                ad_entry.address,
                ad_entry.apartment_number,
                ad_entry.area,
                ad_entry.area_unit,
                ad_entry.balcony_count,
                ad_entry.bathroom_count,
                ad_entry.bedroom_count,
                ad_entry.building_number,
                ad_entry.city,
                ad_entry.city_id,
                ad_entry.condition,
                ad_entry.deal_type,
                ad_entry.district,
                ad_entry.district_id,
                ad_entry.features,
                ad_entry.floor_number,
                ad_entry.function,
                ad_entry.has_air_conditioning,
                ad_entry.has_alarm,
                ad_entry.has_appliances,
                ad_entry.has_conference_hall,
                ad_entry.has_doorphone,
                ad_entry.has_electricity,
                ad_entry.has_fireplace,
                ad_entry.has_furniture,
                ad_entry.has_garage_or_parking,
                ad_entry.has_gas,
                ad_entry.has_generator,
                ad_entry.has_heating,
                ad_entry.has_hot_water,
                ad_entry.has_internet,
                ad_entry.has_inventory,
                ad_entry.has_lift,
                ad_entry.has_loggia,
                ad_entry.has_network,
                ad_entry.has_phone,
                ad_entry.has_security,
                ad_entry.has_sewage,
                ad_entry.has_storage_area,
                ad_entry.has_tv,
                ad_entry.has_veranda,
                ad_entry.has_wardrobe,
                ad_entry.has_water_supply,
                ad_entry.html_copy_path,
                ad_entry.is_bank_real_estate,
                ad_entry.is_mansard,
                ad_entry.is_urgent,
                ad_entry.land_area,
                ad_entry.land_area_unit,
                ad_entry.price,
                ad_entry.price_currency,
                ad_entry.price_per_area_unit,
                ad_entry.price_timeframe,
                ad_entry.project,
                ad_entry.property_type,
                ad_entry.publication_date,
                ad_entry.region,
                ad_entry.region_id,
                ad_entry.room_count,
                ad_entry.seller_name,
                ad_entry.seller_type,
                ad_entry.status,
                ad_entry.telephone_number,
                ad_entry.time_of_scrape,
                ad_entry.total_floor_count,
                ad_entry.street,
                ad_entry.street_id,
                ad_entry.has_stained_glass_windows,
                ad_entry.distance_from_main_road,
                ad_entry.distance_from_tbilisi]
      end
    end
  end
end
