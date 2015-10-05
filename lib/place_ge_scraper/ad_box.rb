require_relative '../../environment'

# Box containing summary of a place.ge real estate ad. Used in lists of
# real estate ads. This scraper uses these ad boxes when searching for ads
# published within a certain time period: if the ad falls in that time period,
# its ID is saved so that its full ad page can be scraped later on
class PlaceGeAdBox
  def initialize(html)
    @html = html
  end

  attr_writer :id

  def scrape_id
    @html.css('.editFilter').children.find { |x| x.text.include? 'ID: ' }.text.remove_non_numbers.to_nil_or_i
  end

  def scrape_pub_date
    pub_date_string = @html.css('.pub-date').children[1].text
    Date.strptime(pub_date_string, '%d.%m.%Y')
  end

  def scrape_is_simple
    @html.attributes['class'].value.include? 'simple-ad'
  end

  def id
    @id = scrape_id if @id.nil?
    @id
  end

  def pub_date
    @pub_date = scrape_pub_date if @pub_date.nil?
    @pub_date
  end

  def simple?
    @is_simple = scrape_is_simple if @is_simple.nil?
    @is_simple
  end

  def between_dates?(start_date, end_date)
    (pub_date >= start_date) && (pub_date <= end_date)
  end

  def link
    PlaceGeAd.link_for_id(id)
  end

  def save
    ad = Ad.find_or_create_by_place_ge_id(id, link)

    # Marks the ad as having an entry that needs to be scraped
    ad.update_column(:has_unscraped_ad_entry, true)
  end
end
