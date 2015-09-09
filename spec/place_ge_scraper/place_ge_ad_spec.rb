require 'place_ge_scraper'

describe 'PlaceGeAd' do
  describe 'ID 459002' do
    it 'price is correct' do
      ad = PlaceGeAd.new('http://place.ge/en/ads/view/459002')
      expect(ad.price).to eq(46000)
    end

    it 'size is correct' do
      ad = PlaceGeAd.new('http://place.ge/en/ads/view/459002')
      expect(ad.size).to eq(56)
    end
  end
end
