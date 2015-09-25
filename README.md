# Place.Ge Scraper

This project grabs information about real estate ads posted on place.ge and stores it in a database.

## Setup

1. Make a copy of the file .env.example in the root directory called .env. Add your mysql database name, the database user and the password for that user.
2. Run 'rake db:create db:migrate' to setup the database.
3. Scrape!

## Scraper tasks

`rake scraper:scrape_ad[252686]` - Scrapes ad with ID 252686 and outputs scraped info, but does not save anything to database.

`rake scraper:scrape_ads_posted_today` - Scrapes ads posted today and saves ad info to database.

`rake scraper:scrape_ads_posted_today[99]` - Scrapes a maximum of 99 ads posted today and saves ad info to database.

`rake scraper:scrape_ads_posted_yesterday` - Scrapes ads posted yesterday and saves ad info to database.

`rake scraper:scrape_ads_posted_yesterday[123]` - Scrapes a maximum of 123 ads posted yesterday and saves ad info to database.

`rake scraper:scrape_ads_posted_in_time_period[2015-09-12,2015-09-14]` - Scrapes ads posted between September 12, 2015 and September 14, 2015 and saves ad info to database.

`rake scraper:scrape_ads_posted_in_time_period[2015-09-12,2015-09-14,666]` - Scrapes a maximum of 666 ads posted between September 12, 2015 and September 14, 2015 and saves ad info to database.

## Logs

- Scraper: log/scraper.log
- Database: log/db.log
