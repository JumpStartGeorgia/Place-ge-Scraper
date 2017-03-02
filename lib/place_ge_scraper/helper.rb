require_relative '../../environment'

# Adds place.ge specific helper methods to String
class String
  def remove_non_numbers
    gsub(/[^0-9]/, '')
  end

  def remove_numbers
    gsub(/[0-9]/, '')
  end

  def to_nil_or_i
    empty? ? nil : to_i
  end

  def to_nil_if_empty
    if empty?
      return nil
    else
      return self
    end
  end
end

# Adds place.ge specific helper methods to Nokogiri
class Nokogiri::XML::Node
  def detail_value(detail_label)
    xpath("//*[contains(concat(' ', @class, ' '), ' detailBox2 ' )][descendant::div[@class='detailLeft'][contains(., '#{detail_label}')]]//*[contains(concat(' ', @class, ' '), ' detailRight ')]/text()").text
  end
end

# update github with any changes
def update_data_github
  unless !ENV['PROJECT_ENV'].empty? && ENV['PROJECT_ENV'].downcase == 'production'
    ScraperLog.logger.info 'NOT updating github because environment is not production'
    return false
  end

  ScraperLog.logger.info 'pushing data files to github'

  `cd data && git add -A`
  `cd data && git commit -m 'Added new the csv file for the last month'`
  `cd data && git push origin master`
end

