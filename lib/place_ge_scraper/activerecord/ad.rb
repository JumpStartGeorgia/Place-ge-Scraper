require_relative '../../../environment'

# An ActiveRecord class for saving a place_ge_id and all the entries
# found with that id
class Ad < ActiveRecord::Base
  has_many :ad_entries

  def self.find_or_create_by_place_ge_id(place_ge_id, link)
    ad = find_by_place_ge_id(place_ge_id)

    if ad.nil?
      ad = Ad.create(
        place_ge_id: place_ge_id,
        link: link
      )
    end

    ad
  end
end
