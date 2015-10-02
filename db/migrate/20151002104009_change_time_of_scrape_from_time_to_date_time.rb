class ChangeTimeOfScrapeFromTimeToDateTime < ActiveRecord::Migration
  def up
    change_column :ad_entries, :time_of_scrape, :datetime
  end

  def down
    change_column :ad_entries, :time_of_scrape, :time
  end
end
