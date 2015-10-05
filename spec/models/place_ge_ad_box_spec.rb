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
        new_saved_ad = new_place_ge_ad_box.save
        expect(new_saved_ad.has_unscraped_ad_entry).to eq(true)
      end
    end

    context 'when other ad with different place_ge_id is in database' do
      it 'creates new ad' do
        expect do
          new_place_ge_ad_box.save
        end.to change(Ad, :count).by(1)
      end

      it 'sets has_unscraped_ad_entry to true' do
        new_saved_ad = new_place_ge_ad_box.save
        expect(new_saved_ad.has_unscraped_ad_entry).to eq(true)
      end
    end

    context 'when other ad with same place_ge_id is in database' do
      let! :other_saved_ad_box do
        other_place_ge_ad_box.save
      end

      it 'does not create new ad' do
        expect do
          new_place_ge_ad_box.save
        end.to change(Ad, :count).by(0)
      end

      it 'sets has_unscraped_ad_entry for other ad to true' do
        expect(other_saved_ad_box.has_unscraped_ad_entry).to eq(true)
      end
    end
  end
end
