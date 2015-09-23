class AddLinkToRealEstateAds < ActiveRecord::Migration
  def change
    add_column :real_estate_ads, :link, :string
  end
end
