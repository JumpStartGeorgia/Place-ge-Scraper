class AddIndecesToAdEntriesTableColumns < ActiveRecord::Migration
  def change
    add_index :ad_entries, :place_ge_id
    add_index :ad_entries, :city_id
    add_index :ad_entries, :region_id
    add_index :ad_entries, :district_id
    add_index :ad_entries, :price
    add_index :ad_entries, :price_timeframe
    add_index :ad_entries, :area
    add_index :ad_entries, :land_area
  end
end
