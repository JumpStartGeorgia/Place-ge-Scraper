require_relative '../../../environment'

class Property < ActiveRecord::Base
  has_many :ad_entries

  

end