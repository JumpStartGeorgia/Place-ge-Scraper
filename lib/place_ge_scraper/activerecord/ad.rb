require_relative '../../../environment'

# An ActiveRecord class for saving a place_ge_id and all the entries
# found with that id
class Ad < ActiveRecord::Base
  has_many :ad_entries

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

  def self.to_iset_csv(start_date, end_date)
    ad_entries = AdEntry
                 .published_on_or_after(start_date)
                 .published_on_or_before(end_date)
                 .most_recent_entry_for_each_ad

    require 'csv'
    CSV.open('Place.Ge Real Estate Data.csv', 'wb') do |csv|
      csv << %w(pid price 'month', 'year', 'area', 'larea', 'type', 'otype', 'cid', 'rid', 'did', 'tagged_sid', 'renovation', 'nrooms', 'nbeds', 'nbaths', 'nbalcs', 'wfloor', 'status')

      ad_entries.each do |ad_entry|
        csv << [ad_entry.ad.place_ge_id, ad_entry.full_price, ad_entry.publication_date.month, ad_entry.publication_date.year, ad_entry.area, ad_entry.land_area, ad_entry.deal_type, ad_entry.property_type, ad_entry.city, ad_entry.region, ad_entry.district, ad_entry.street, ad_entry.condition, ad_entry.room_count, ad_entry.bedroom_count, ad_entry.bathroom_count, ad_entry.balcony_count, ad_entry.floor_number, ad_entry.status]
      end
    end
  end
end
