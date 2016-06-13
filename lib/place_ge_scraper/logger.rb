module ScraperLog
  def self.logger
    Logger.new('log/scraper.log')
  end
end

module AdInfo
  def self.logger
    Logger.new('log/ad_info.log')
  end
end
