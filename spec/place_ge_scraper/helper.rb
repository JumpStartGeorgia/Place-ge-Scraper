require 'place_ge_scraper'

def test_place_ge_ad(id, expected)
  describe 'PlaceGeAd' do
    describe "ID #{id}" do
      before :context do
        @ad = PlaceGeAd.new("http://place.ge/en/ads/view/#{id}")
      end

      it 'price is correct' do
        expect(@ad.price).to eq(expected[:price])
      end

      it 'size is correct' do
        expect(@ad.size).to eq(expected[:size])
      end

      it 'size_unit is correct' do
        expect(@ad.size_unit).to eq(expected[:size_unit])
      end

      it 'renovation_type is correct' do
        expect(@ad.renovation_type).to eq(expected[:renovation_type])
      end

      it 'address is correct' do
        expect(@ad.address).to eq(expected[:address])
      end

      it 'city is correct' do
        expect(@ad.city).to eq(expected[:city])
      end

      it 'area is correct' do
        expect(@ad.area).to eq(expected[:area])
      end

      it 'district is correct' do
        expect(@ad.district).to eq(expected[:district])
      end

      it 'street is correct' do
        expect(@ad.street).to eq(expected[:street])
      end

      it 'building_number is correct' do
        expect(@ad.building_number).to eq(expected[:building_number])
      end

      it 'apartment_number is correct' do
        expect(@ad.apartment_number).to eq(expected[:apartment_number])
      end
    end
  end
end
