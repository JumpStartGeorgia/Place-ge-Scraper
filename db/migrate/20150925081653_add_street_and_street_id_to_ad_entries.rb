class AddStreetAndStreetIdToAdEntries < ActiveRecord::Migration
  def change
    add_column :ad_entries, :street, :string
    add_column :ad_entries, :street_id, :integer
    add_index :ad_entries, :street_id
  end
end
