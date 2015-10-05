describe 'PlaceGeAdBox' do
  let :new_place_ge_ad do
    PlaceGeAdFactory.build
  end

  let :other_place_ge_ad do
    PlaceGeAdFactory.build
  end

  describe 'save' do
    it 'creates ad entry with correct time of scrape' do
      new_saved_entry = new_place_ge_ad.save
      new_saved_entry.reload
      expect(new_saved_entry.time_of_scrape).to eq(new_place_ge_ad.time_of_scrape)
    end

    context 'when no other ads are saved in database' do
      it 'creates ad_entry' do
        expect do
          new_place_ge_ad.save
        end.to change(AdEntry, :count).by(1)
      end

      it 'creates new ad' do
        expect do
          new_place_ge_ad.save
        end.to change(Ad, :count).by(1)
      end
    end

    context 'when same place_ge_ad but with different place_ge_id is saved' do
      let! :saved_entry_different_id do
        other_place_ge_ad.place_ge_id
      end

      it 'creates new ad entry' do
        expect do
          new_place_ge_ad.save
        end.to change(AdEntry, :count).by(1)
      end

      it 'creates new ad' do
        expect do
          new_place_ge_ad.save
        end.to change(Ad, :count).by(1)
      end
    end

    context 'when almost identical place_ge_ad but with old publication date is saved' do
      let! :different_saved_entry do
        other_place_ge_ad.publication_date = new_place_ge_ad.publication_date + 1
        other_place_ge_ad.save
      end

      it 'creates new ad entry' do
        expect do
          new_place_ge_ad.save
        end.to change(AdEntry, :count).by(1)
      end

      it 'does not create new ad' do
        expect do
          new_place_ge_ad.save
        end.to change(Ad, :count).by(0)
      end
    end

    context 'when identical place_ge_ad has already been saved' do
      let! :identical_saved_entry do
        other_place_ge_ad.save
      end

      it 'does not create ad_entry' do
        expect do
          new_place_ge_ad.save
        end.to change(AdEntry, :count).by(0)
      end

      it 'does not create new ad' do
        expect do
          new_place_ge_ad.save
        end.to change(Ad, :count).by(0)
      end

      it 'should update time of scrape of identical place_ge_ad' do
        sleep 1
        new_place_ge_ad.save
        identical_saved_entry.reload
        expect(identical_saved_entry.time_of_scrape).to eq(new_place_ge_ad.time_of_scrape)
      end
    end
  end
end
