# Place.Ge Scraper

This project grabs information about real estate ads posted on place.ge and stores it in a database.

## Setup

1. `bundle install`
2. Make a copy of the file `.env.example` called `.env` in the root directory and add values to all variables.
3. `rake db:create db:migrate`
4. Scrape!

## Understanding Place.Ge

Ads on place.ge are often updated with new publication dates or other information. For that reason, this project's database stores ad info in two tables: ads and ad entries. Ads contain the place.ge id of the ad and the link to the ad page, while ad entries contain all the ad info, such as its price, size, etc. One ad can have multiple ad entries, allowing the scraper to store multiple versions of the ad. For example, if the scraper finds ad \#123 on Monday, and then finds ad \#123 again on Friday because it has been reposted, then both versions of the ad will be saved.

## How the scraper works

There are two main steps involved in scraping ad info and storing it in the database:
  1. Scrape the ad ids -> The scraper goes and finds the ids for ads that have been posted in a certain time period. In the process, it saves these ids in the `ads` table, flagging each of them with `has_unscraped_ad_entry`. This can be done with commands such as `rake scraper:scrape_ad_ids_posted_today`.
  2. Scrape the ad info -> The scraper gets all the ads from the database that are flagged with `has_unscraped_ad_entry`, and then goes and scrapes the data for those ads. To do this, run `rake scraper:scrape_ads_flagged_unscraped`.

## Scraper task examples

`rake scraper:scrape_and_output_ad[252686]` - Scrapes ad with ID 252686 and outputs scraped info, but does not save anything to database.

`rake scraper:scrape_ad_ids_posted_today` - Scrapes the ids of ads posted today, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ad_ids_posted_today[99]` - Scrapes the ids of a maximum of 99 ads posted today, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ad_ids_posted_yesterday` - Scrapes the ids of ads posted yesterday, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ad_ids_posted_yesterday[123]` - Scrapes the ids of a maximum of 123 ads posted yesterday, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ad_ids_posted_in_time_period[2015-09-12,2015-09-14]` - Scrapes ids of ads posted between September 12, 2015 and September 14, 2015, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ad_ids_posted_in_time_period[2015-09-12,2015-09-14,666]` - Scrapes ids of a maximum of 666 ads posted between September 12, 2015 and September 14, 2015, saves them to database and flags them as having an unscraped ad entry.

`rake scraper:scrape_ads_flagged_unscraped` - Scrapes ad entries for ads flagged as in need of scraping.

## Logs

- Scraper: `log/scraper.log`
- Database: `log/db.log`
