class RenameRealEstateAdsToRealEstateAdEntries < ActiveRecord::Migration
  def change
    rename_table :real_estate_ads, :ad_entries
  end
end
