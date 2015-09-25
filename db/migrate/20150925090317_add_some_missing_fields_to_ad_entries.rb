class AddSomeMissingFieldsToAdEntries < ActiveRecord::Migration
  def change
    add_column :ad_entries, :has_stained_glass_windows, :boolean
    add_column :ad_entries, :distance_from_main_road, :text
    add_column :ad_entries, :distance_from_tbilisi, :text
  end
end
