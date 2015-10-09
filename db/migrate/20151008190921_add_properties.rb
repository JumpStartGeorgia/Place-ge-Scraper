class AddProperties < ActiveRecord::Migration
  def up
    create_table :properties do |t|
      t.datetime :created_at
    end

    add_column :ad_entries, :property_id, :integer
    add_column :ad_entries, :is_primary, :boolean, defualt: false
    add_index :ad_entries, :property_id
    add_index :ad_entries, :is_primary

    add_index :ad_entries, :publication_date
  end

  def down
    drop_table :properties

    remove_index :ad_entries, :property_id
    remove_index :ad_entries, :is_primary
    remove_column :ad_entries, :property_id
    remove_column :ad_entries, :is_primary

    remove_index :ad_entries, :publication_date
  end
end
