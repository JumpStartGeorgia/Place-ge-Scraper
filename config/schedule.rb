job_type :run_rake_task, 'cd :path && bundle exec rake :task --quiet'

every '0 20 14 * *' do
  run_rake_task 'scraper:main_scrape_tasks:last_month'
end
