require_relative '../../lib/tasks/helpers.rb'

describe 'Rake Task Helpers' do
  describe '#previous_month_start_and_end_dates' do
    context 'when date is in February' do
      it 'returns first and last days of January' do
        date = Date.new(2015, 2, 1)
        expect(previous_month_start_and_end_dates(date))
          .to eq([Date.new(2015, 1, 1), Date.new(2015, 1, 31)])
      end
    end

    context 'when date is in April' do
      it 'returns first and last days of March' do
        date = Date.new(2015, 4, 20)
        expect(previous_month_start_and_end_dates(date))
          .to eq([Date.new(2015, 3, 1), Date.new(2015, 3, 31)])
      end
    end

    context 'when date is in July' do
      it 'returns first and last days of June' do
        date = Date.new(2015, 7, 10)
        expect(previous_month_start_and_end_dates(date))
          .to eq([Date.new(2015, 6, 1), Date.new(2015, 6, 30)])
      end
    end
  end
end
