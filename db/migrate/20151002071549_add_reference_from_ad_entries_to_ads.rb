class AddReferenceFromAdEntriesToAds < ActiveRecord::Migration
  def change
    add_reference :ad_entries, :ad, index: true
  end
end
