class AddIndexesForDuplicateAnalysis < ActiveRecord::Migration
  def change
    add_index :ad_entries, :price_currency
    add_index :ad_entries, :property_type
    add_index :ad_entries, :deal_type
    add_index :ad_entries, :room_count
  end
end
