require_relative '../../../environment'

# An ActiveRecord class for saving a place_ge_id and all the entries
# found with that id
class Ad < ActiveRecord::Base
  has_many :ad_entries
end
