require_relative '../../../environment'

# An ActiveRecord class for saving data in a place.ge ad entry in a database
class AdEntry < ActiveRecord::Base
  belongs_to :ad
  belongs_to :property

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

  def self.is_primary_property
    where(is_primary: true)
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



  # look for two types of duplicates
  # - if have same ad_id in same month -> duplicate
  # - if primary fields match -> duplicate (i.e., price, area, address, etc)
  # - make all duplicates have same property id
  #   and set the most recent duplicate as the clean record
  # any records that are not a duplicate get their own property id and is primary set to true
  def self.identify_duplicates_for_month_year(month, year)
    # get records for the provided month and year
    records_to_check = where(['month(publication_date) = :month and year(publication_date) = :year', month: month, year: year]).count
    if records_to_check > 0
      AdEntry.transaction do
        puts ">> there are #{records_to_check} records in #{month} #{year}"

        # reset the property id for these records
        where(['month(publication_date) = :month and year(publication_date) = :year', month: month, year: year]).update_all(property_id: nil, is_primary: false)

        puts "-----------"
        puts ">> - looking for duplicate ad ids"

        # get records that have same ad_id
        sql = "select ad1.id as ad1_id, ad1.property_id as ad1_property_id, ad2.id as ad2_id, ad2.property_id as ad2_property_id from ad_entries as ad1 "
        sql << "inner join ad_entries as ad2 on "
        sql << "     ad1.id < ad2.id "
        sql << "  and ad1.ad_id = ad2.ad_id "
        sql << "  and month(ad1.publication_date) = month(ad2.publication_date) "
        sql << "  and year(ad1.publication_date) = year(ad2.publication_date) "
        sql << "where "
        sql << "month(ad1.publication_date) = :month "
        sql << "and year(ad1.publication_date) = :year "
        sql << "order by ad1.id "
        duplicate_ad_ids = find_by_sql([sql, month: month, year: year])
        if duplicate_ad_ids.length > 0
          puts ">> - found #{duplicate_ad_ids.length} records with duplicate ad ids"

          duplicate_ad_ids.each do |duplicate|
            p = Property.create

            AdEntry.where(id: [duplicate['ad1_id'], duplicate['ad2_id']]).update_all(property_id: p.id)
          end

          puts ">> - done saving property for duplicate ad ids"
        end

        puts "-----------"
        puts ">> - looking for duplicate records by matching fields"

        # look for duplicates by comparing fields
        sql = "select ad1.id as ad1_id, ad2.id as ad2_id "
        sql << "from ad_entries as ad1 "
        sql << "inner join ad_entries as ad2 on "
        sql << "      ad1.id < ad2.id "
        sql << "  and month(ad1.publication_date) = month(ad2.publication_date) "
        sql << "  and year(ad1.publication_date) = year(ad2.publication_date)  "
        sql << "  and ad1.price = ad2.price "
        sql << "  and ad1.price_currency = ad2.price_currency "
        sql << "  and ad1.price_timeframe = ad2.price_timeframe "
        sql << "  and ad1.area = ad2.area "
        sql << "  and ad1.city_id = ad2.city_id "
        sql << "  and ad1.region_id = ad2.region_id "
        sql << "  and ad1.district_id = ad2.district_id "
        sql << "  and ad1.room_count = ad2.room_count "
        sql << "  and ad1.bedroom_count = ad2.bedroom_count  "
        sql << "where  "
        sql << "month(ad1.publication_date) = :month "
        sql << "and year(ad1.publication_date) = :year "
        sql << "order by ad1.id "

        duplicates = find_by_sql([sql, month: month, year: year])
        if duplicates.length > 0
          puts ">> - found #{duplicates.length} records with matching fields"

          unique_ids = duplicates.map{|x| x['ad1_id']}.uniq
          unique_ids.each do |unique_id|
            # if this id does not have a property id, add it
            ad = where(id: unique_id).first
            if !ad.nil? && ad.property_id.nil?
              matching_duplicate_ids = duplicates.select{|x| x['ad1_id'] == unique_id}.map{|x| x['ad2_id']}
              # puts ">>> - adding property id for #{unique_id} and duplicate ids #{matching_duplicate_ids}"

              p = Property.create
              where(id: matching_duplicate_ids.push(unique_id)).update_all(property_id: p.id)
            end
          end
          puts ">> - done saving property for duplicate matching fields"
        end

        puts "-----------"

        puts ">> - for each property with duplicates, mark the most recent one as primary"

        properties = where(['month(publication_date) = :month and year(publication_date) = :year and property_id is not null', month: month, year: year]).pluck(:property_id).uniq
        properties.each do |property|
          # the ad with the most recent date will have is_primary flag set to true
          sql = "select id, publication_date from ad_entries where property_id = :property_id order by publication_date desc"
          properties = find_by_sql([sql, property_id: property['property_id']])
          where(id: properties.first['id']).update_all(is_primary: true) if properties.length > 0
        end

        puts "-----------"

        puts ">> - all other records are not duplicates, so give unique property id"
        where(['month(publication_date) = :month and year(publication_date) = :year and property_id is null', month: month, year: year]).each do |ad|
          ad.property_id = Property.create.id
          ad.is_primary = true
          ad.save
        end
      end
    end
  end

end
