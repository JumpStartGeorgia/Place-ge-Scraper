class AddPropertySubType < ActiveRecord::Migration
  def change
    add_column :ad_entries, :property_sub_type, :string, after: :property_type
  end
end
