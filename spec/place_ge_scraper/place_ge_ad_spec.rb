require 'place_ge_scraper'

describe 'PlaceGeAd' do
  describe 'ID 459002' do
    let!(:ad) { PlaceGeAd.new('http://place.ge/en/ads/view/459002') }

    it 'price is correct' do
      expect(ad.price).to eq(46000)
    end

    it 'size is correct' do
      expect(ad.size).to eq(56)
    end

    it 'size_unit is correct' do
      expect(ad.size_unit).to eq('sq. m.')
    end

    it 'renovation_type is correct' do
      expect(ad.renovation_type).to eq('Old renovated')
    end

    it 'address is correct' do
      expect(ad.address).to eq('Tbilisi, Vake-Saburtalo, Saburtalo, Kavtaradze st.')
    end

    it 'city is correct' do
      expect(ad.city).to eq('Tbilisi')
    end

    it 'area is correct' do
      expect(ad.area).to eq('Vake-Saburtalo')
    end

    it 'district is correct' do
      expect(ad.district).to eq('Saburtalo')
    end

    it 'street is correct' do
      expect(ad.street).to eq('Kavtaradze st.')
    end

    it 'building_number is correct' do
      expect(ad.building_number).to eq('13')
    end

    it 'apartment_number is correct' do
      expect(ad.apartment_number).to eq('6')
    end
  end
end
