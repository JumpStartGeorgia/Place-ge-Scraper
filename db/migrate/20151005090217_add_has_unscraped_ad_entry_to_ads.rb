class AddHasUnscrapedAdEntryToAds < ActiveRecord::Migration
  def change
    add_column :ads, :has_unscraped_ad_entry, :boolean
  end
end
