describe 'PlaceGeAd' do
  let(:new_place_ge_ad) do
    PlaceGeAdFactory.build
  end

  describe 'save' do
    it 'creates ad_entry' do
      expect do
        new_place_ge_ad.save
      end.to change(AdEntry, :count).by(1)
    end
  end
end
