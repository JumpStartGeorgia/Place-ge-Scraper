describe 'PlaceGeAdBox' do
  let :new_place_ge_ad_box do
    PlaceGeAdBoxFactory.build
  end

  let :other_place_ge_ad_box do
    PlaceGeAdBoxFactory.build
  end

  describe 'save' do
    context 'when no other ads are saved in database' do
      it 'creates new ad' do
        expect do
          new_place_ge_ad_box.save
        end.to change(Ad, :count).by(1)
      end

      it 'sets has_unscraped_ad_entry to true' do
        skip
      end
    end

    context 'when other ad with different place_ge_id is in database' do
      it 'creates new ad' do
        skip
      end

      it 'sets has_unscraped_ad_entry to true' do
        skip
      end
    end

    context 'when other ad with same place_ge_id is in database' do
      it 'does not create new ad' do
        skip
      end

      it 'sets has_unscraped_ad_entry for other ad to true' do
        skip
      end
    end
  end
end
