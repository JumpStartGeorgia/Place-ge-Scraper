require 'place_ge_scraper'

def test_place_ge_ad(id, expected)
  describe 'PlaceGeAd' do
    describe "ID #{id}" do
      before :context do
        @ad = PlaceGeAd.new(id)
      end

      it 'place_ge_id is correct' do
        expect(@ad.place_ge_id).to eq(expected[:place_ge_id])
      end

      it 'link is correct' do
        expect(@ad.link).to eq(expected[:link])
      end

      it 'publication_date is correct' do
        expect(@ad.publication_date).to eq(expected[:publication_date])
      end

      it 'deal_type is correct' do
        expect(@ad.deal_type).to eq(expected[:deal_type])
      end

      it 'property_type is correct' do
        expect(@ad.property_type).to eq(expected[:property_type])
      end

      it 'city_id is correct' do
        expect(@ad.city_id).to eq(expected[:city_id])
      end

      it 'city is correct' do
        expect(@ad.city).to eq(expected[:city])
      end

      it 'region_id is correct' do
        expect(@ad.region_id).to eq(expected[:region_id])
      end

      it 'region is correct' do
        expect(@ad.region).to eq(expected[:region])
      end

      it 'district_id is correct' do
        expect(@ad.district_id).to eq(expected[:district_id])
      end

      it 'district is correct' do
        expect(@ad.district).to eq(expected[:district])
      end

      it 'street_id is correct' do
        expect(@ad.street_id).to eq(expected[:street_id])
      end

      it 'street is correct' do
        expect(@ad.street).to eq(expected[:street])
      end

      it 'price is correct' do
        expect(@ad.price).to eq(expected[:price])
      end

      it 'price_per_area_unit is correct' do
        expect(@ad.price_per_area_unit).to eq(expected[:price_per_area_unit])
      end

      it 'price_currency is correct' do
        expect(@ad.price_currency).to eq(expected[:price_currency])
      end

      it 'price_timeframe is correct' do
        expect(@ad.price_timeframe).to eq(expected[:price_timeframe])
      end

      it 'area is correct' do
        expect(@ad.area).to eq(expected[:area])
      end

      it 'area_unit is correct' do
        expect(@ad.area_unit).to eq(expected[:area_unit])
      end

      it 'land_area is correct' do
        expect(@ad.land_area).to eq(expected[:land_area])
      end

      it 'land_area_unit is correct' do
        expect(@ad.land_area_unit).to eq(expected[:land_area_unit])
      end

      it 'distance_from_tbilisi is correct' do
        skip('Have not found a place.ge ad with this field')
        expect(@ad.distance_from_tbilisi).to eq(expected[:distance_from_tbilisi])
      end

      it 'distance_from_main_road is correct' do
        skip('Have not found a place.ge ad with this field')
        expect(@ad.distance_from_main_road).to eq(expected[:distance_from_main_road])
      end

      it 'function is correct' do
        expect(@ad.function).to eq(expected[:function])
      end

      it 'condition is correct' do
        expect(@ad.condition).to eq(expected[:condition])
      end

      it 'project is correct' do
        expect(@ad.project).to eq(expected[:project])
      end

      it 'status is correct' do
        expect(@ad.status).to eq(expected[:status])
      end

      it 'array is correct' do
        skip('Have not found a place.ge ad with this field')
        expect(@ad.array).to eq(expected[:array])
      end

      it 'quarter is correct' do
        skip('Have not found a place.ge ad with this field')
        expect(@ad.quarter).to eq(expected[:quarter])
      end

      it 'neighborhood is correct' do
        skip('Have not found a place.ge ad with this field')
        expect(@ad.neighborhood).to eq(expected[:neighborhood])
      end

      it 'building_number is correct' do
        expect(@ad.building_number).to eq(expected[:building_number])
      end

      it 'apartment_number is correct' do
        expect(@ad.apartment_number).to eq(expected[:apartment_number])
      end

      it 'address is correct' do
        expect(@ad.address).to eq(expected[:address])
      end

      it 'floor_number is correct' do
        expect(@ad.floor_number).to eq(expected[:floor_number])
      end

      it 'total_floor_count is correct' do
        expect(@ad.total_floor_count).to eq(expected[:total_floor_count])
      end

      it 'room_count is correct' do
        expect(@ad.room_count).to eq(expected[:room_count])
      end

      it 'bathroom_count is correct' do
        expect(@ad.bathroom_count).to eq(expected[:bathroom_count])
      end

      it 'bedroom_count is correct' do
        expect(@ad.bedroom_count).to eq(expected[:bedroom_count])
      end

      it 'balcony_count is correct' do
        expect(@ad.balcony_count).to eq(expected[:balcony_count])
      end

      it 'is_bank_real_estate is correct' do
        expect(@ad.is_bank_real_estate).to eq(expected[:is_bank_real_estate])
      end

      it 'has_garage_or_parking is correct' do
        expect(@ad.has_garage_or_parking).to eq(expected[:has_garage_or_parking])
      end

      it 'has_lift is correct' do
        expect(@ad.has_lift).to eq(expected[:has_lift])
      end

      it 'has_furniture is correct' do
        expect(@ad.has_furniture).to eq(expected[:has_furniture])
      end

      it 'has_fireplace is correct' do
        expect(@ad.has_fireplace).to eq(expected[:has_fireplace])
      end

      it 'has_storage_area is correct' do
        expect(@ad.has_storage_area).to eq(expected[:has_storage_area])
      end

      it 'has_wardrobe is correct' do
        expect(@ad.has_wardrobe).to eq(expected[:has_wardrobe])
      end

      it 'has_air_conditioning is correct' do
        expect(@ad.has_air_conditioning).to eq(expected[:has_air_conditioning])
      end

      it 'has_heating is correct' do
        expect(@ad.has_heating).to eq(expected[:has_heating])
      end

      it 'has_loggia is correct' do
        expect(@ad.has_loggia).to eq(expected[:has_loggia])
      end

      it 'has_appliances is correct' do
        expect(@ad.has_appliances).to eq(expected[:has_appliances])
      end

      it 'has_hot_water is correct' do
        expect(@ad.has_hot_water).to eq(expected[:has_hot_water])
      end

      it 'has_tv is correct' do
        expect(@ad.has_tv).to eq(expected[:has_tv])
      end

      it 'has_phone is correct' do
        expect(@ad.has_phone).to eq(expected[:has_phone])
      end

      it 'has_internet is correct' do
        expect(@ad.has_internet).to eq(expected[:has_internet])
      end

      it 'has_alarm is correct' do
        expect(@ad.has_alarm).to eq(expected[:has_alarm])
      end

      it 'has_doorphone is correct' do
        expect(@ad.has_doorphone).to eq(expected[:has_doorphone])
      end

      it 'has_security is correct' do
        expect(@ad.has_security).to eq(expected[:has_security])
      end

      it 'has_conference_hall is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_conference_hall).to eq(expected[:has_conference_hall])
      end

      it 'has_showcase is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_showcase).to eq(expected[:has_showcase])
      end

      it 'has_veranda is correct' do
        expect(@ad.has_veranda).to eq(expected[:has_veranda])
      end

      it 'is_mansard is correct' do
        expect(@ad.is_mansard).to eq(expected[:is_mansard])
      end

      it 'has_electricity is correct' do
        expect(@ad.has_electricity).to eq(expected[:has_electricity])
      end

      it 'has_gas is correct' do
        expect(@ad.has_gas).to eq(expected[:has_gas])
      end

      it 'has_water_supply is correct' do
        expect(@ad.has_water_supply).to eq(expected[:has_water_supply])
      end

      it 'has_sewage is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_sewage).to eq(expected[:has_sewage])
      end

      it 'has_inventory is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_inventory).to eq(expected[:has_inventory])
      end

      it 'has_network is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_network).to eq(expected[:has_network])
      end

      it 'has_generator is correct' do
        skip('Need to scrape features string for this feature before enabling this test')
        expect(@ad.has_generator).to eq(expected[:has_generator])
      end

      it 'additional_information is correct' do
        expect(@ad.additional_information).to eq(expected[:additional_information])
      end

      it 'telephone_number is correct' do
        expect(@ad.telephone_number).to eq(expected[:telephone_number])
      end

      it 'seller_type is correct' do
        expect(@ad.seller_type).to eq(expected[:seller_type])
      end

      it 'seller_name is correct' do
        expect(@ad.seller_name).to eq(expected[:seller_name])
      end
    end
  end
end
