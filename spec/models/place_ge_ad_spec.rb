describe 'PlaceGeAd' do
  let(:new_place_ge_ad) do
    new_place_ge_ad = PlaceGeAd.new(123_456)

    new_place_ge_ad.publication_date = Date.new(2015, 6, 22)
    new_place_ge_ad.deal_type = 'for_rent'
    new_place_ge_ad.property_type = 'flat'
    new_place_ge_ad.city_id = 1
    new_place_ge_ad.city = 'Tbilisi'
    new_place_ge_ad.region_id = 1
    new_place_ge_ad.region = 'Vake-Saburtalo'
    new_place_ge_ad.district_id = 2
    new_place_ge_ad.district = 'Vake'
    new_place_ge_ad.street_id = 47
    new_place_ge_ad.street = 'N. Djvania st.'
    new_place_ge_ad.is_urgent = true
    new_place_ge_ad.price = '1050'
    new_place_ge_ad.price_per_area_unit = '11'
    new_place_ge_ad.price_currency = 'dollar'
    new_place_ge_ad.price_timeframe = 'month'
    new_place_ge_ad.area = '93'
    new_place_ge_ad.area_unit = 'sq. m.'
    new_place_ge_ad.land_area = nil
    new_place_ge_ad.land_area_unit = nil
    new_place_ge_ad.distance_from_tbilisi = nil
    new_place_ge_ad.distance_from_main_road = nil
    new_place_ge_ad.function = nil
    new_place_ge_ad.condition = 'Newly renovated'
    new_place_ge_ad.project = 'Moscow'
    new_place_ge_ad.status = 'new building'
    new_place_ge_ad.building_number = '28'
    new_place_ge_ad.apartment_number = nil
    new_place_ge_ad.address = 'Tbilisi, Vake-Saburtalo, Vake, N. Djvania st.'
    new_place_ge_ad.floor_number = '6'
    new_place_ge_ad.total_floor_count = '7'
    new_place_ge_ad.room_count = '2'
    new_place_ge_ad.bathroom_count = '1'
    new_place_ge_ad.bedroom_count = '1'
    new_place_ge_ad.balcony_count = '1'
    new_place_ge_ad.features = 'Garage / Parking, Appliances, Air conditioning, Heating, Hot water, Television, Telephone, Internet, Doorphone, Guard, Elevator.'
    new_place_ge_ad.is_bank_real_estate = false
    new_place_ge_ad.has_garage_or_parking = true
    new_place_ge_ad.has_lift = true
    new_place_ge_ad.has_furniture = false
    new_place_ge_ad.has_fireplace = false
    new_place_ge_ad.has_storage_area = false
    new_place_ge_ad.has_wardrobe = false
    new_place_ge_ad.has_air_conditioning = true
    new_place_ge_ad.has_heating = true
    new_place_ge_ad.has_loggia = false
    new_place_ge_ad.has_appliances = true
    new_place_ge_ad.has_hot_water = true
    new_place_ge_ad.has_tv = true
    new_place_ge_ad.has_phone = true
    new_place_ge_ad.has_internet = true
    new_place_ge_ad.has_alarm = false
    new_place_ge_ad.has_doorphone = true
    new_place_ge_ad.has_security = true
    new_place_ge_ad.has_conference_hall = false
    new_place_ge_ad.has_stained_glass_windows = false
    new_place_ge_ad.has_veranda = false
    new_place_ge_ad.is_mansard = false
    new_place_ge_ad.has_electricity = false
    new_place_ge_ad.has_gas = false
    new_place_ge_ad.has_water_supply = false
    new_place_ge_ad.has_sewage = false
    new_place_ge_ad.has_inventory = false
    new_place_ge_ad.has_network = false
    new_place_ge_ad.has_generator = false
    new_place_ge_ad.additional_information = 'Новая квартира в эко-комплексе "Тбилисия". В квартире сделан евро-ремонт. Вся техника и сантехника новая. Сантехника испанская фирма ROCA, техника фирма BOSH Подробнее на www.tbilisia.ru/ge'
    new_place_ge_ad.telephone_number = '599076763, 599070026'
    new_place_ge_ad.seller_type = 'Company'
    new_place_ge_ad.seller_name = 'THECO limited'
    new_place_ge_ad
  end

  describe 'save' do
    it 'creates ad_entry' do
      expect do
        new_place_ge_ad.save
      end.to change(AdEntry, :count).by(1)
    end
  end
end
