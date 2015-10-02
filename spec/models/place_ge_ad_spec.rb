describe 'PlaceGeAd' do
  let :new_place_ge_ad do
    PlaceGeAdFactory.build
  end

  let :other_place_ge_ad do
    PlaceGeAdFactory.build
  end

  describe 'save' do
    it 'creates ad_entry' do
      expect do
        new_place_ge_ad.save
      end.to change(AdEntry, :count).by(1)
    end

    context 'when identical place_ge_ad has already been saved' do
      before :example do
        other_place_ge_ad.save
      end

      it 'does not create ad_entry' do
        expect do
          new_place_ge_ad.save
        end.to change(AdEntry, :count).by(0)
      end
    end
  end
end
