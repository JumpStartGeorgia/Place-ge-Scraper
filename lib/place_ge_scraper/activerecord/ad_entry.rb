require_relative '../../../environment'

# An ActiveRecord class for saving data in a place.ge ad entry in a database
class AdEntry < ActiveRecord::Base

  # Gets all attributes except for id and time of scrape, which are unrelated
  # to the actual info on place.ge
  def place_ge_entry_attributes
    attributes.except('id').except('time_of_scrape')
  end
end
