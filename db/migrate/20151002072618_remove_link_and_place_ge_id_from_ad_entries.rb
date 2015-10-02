class RemoveLinkAndPlaceGeIdFromAdEntries < ActiveRecord::Migration
  def change
    remove_column :ad_entries, :place_ge_id
    remove_column :ad_entries, :link
  end
end
