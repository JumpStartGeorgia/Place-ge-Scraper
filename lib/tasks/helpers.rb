def clean_limit(unclean_limit)
  return nil if unclean_limit.nil?
  return nil unless unclean_limit =~ /[[:digit:]]/
  unclean_limit.to_i
end

def process_start_date(start_date)
  ScraperLog.logger.error 'Please provide a start date' if start_date.nil?
  begin
    Date.strptime(start_date, '%Y-%m-%d')
  rescue StandardError
    ScraperLog.logger.error 'Start date cannot be parsed'
    fail
  end
end

def process_end_date(end_date)
  ScraperLog.logger.error 'Please provide an end date' if end_date.nil?
  begin
    Date.strptime(end_date, '%Y-%m-%d')
  rescue StandardError
    ScraperLog.logger.error 'End date cannot be parsed'
    fail
  end
end

def previous_month_start_and_end_dates(date)
  start_date = date.last_month.at_beginning_of_month
  end_date = date.last_month.at_end_of_month

  [start_date, end_date]
end
