class CreateAdsTable < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :place_ge_id
    end
  end
end
