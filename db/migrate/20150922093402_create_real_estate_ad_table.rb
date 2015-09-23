class CreateRealEstateAdTable < ActiveRecord::Migration
  def change
    create_table :real_estate_ads do |t|
      t.integer :place_ge_id
    end
  end
end
