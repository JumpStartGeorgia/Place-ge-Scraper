# The scraper log is wrapped in this module so it is accessible in other files
module ScraperLog
  def self.logger
    Logger.new('log/scraper.log')
  end
end
