every '0 2 8 * *' do
  rake 'scraper:main_scrape_tasks:last_month'
end
