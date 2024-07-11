require 'rails_helper'

RSpec.describe Log, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      log = build(:log)
      expect(log).to be_valid
    end

    it 'is invalid without input' do
      log = build(:log, input: nil)
      expect(log).not_to be_valid
      expect(log.errors[:input]).to include("can't be blank", "is too short (minimum is 3 characters)")
    end

    it 'is invalid with input shorter than 3 characters' do
      log = build(:log, input: "Hi")
      expect(log).not_to be_valid
      expect(log.errors[:input]).to include("is too short (minimum is 3 characters)")
    end

    it 'is invalid without an ip' do
      log = build(:log, ip: nil)
      expect(log).not_to be_valid
      expect(log.errors[:ip]).to include("can't be blank", "must be a valid IPv4 address")
    end

    it 'is invalid with an incorrect ip format' do
      log = build(:log, ip: "999.999.999.999")
      expect(log).not_to be_valid
      expect(log.errors[:ip]).to include("must be a valid IPv4 address")
    end

    it 'is invalid without a country' do
      log = build(:log, country: nil)
      expect(log).not_to be_valid
      expect(log.errors[:country]).to include("can't be blank")
    end

    it 'is invalid without is_processed' do
      log = build(:log, is_processed: nil)
      expect(log).not_to be_valid
      expect(log.errors[:is_processed]).to include("is not included in the list")
    end
  end

  describe '.top_five_inputs' do
    context 'when there are processed logs' do
      before do
        create_list(:log, 3, input: 'Test Input 1', is_processed: true)
        create_list(:log, 2, input: 'Test Input 2', is_processed: true)
        create_list(:log, 1, input: 'Test Input 3', is_processed: true)
      end

      it 'returns the top inputs by count' do
        result = Log.top_five_inputs
        expect(result.map(&:input)).to eq(['Test Input 1', 'Test Input 2', 'Test Input 3'])
      end
    end

    context 'when there are unprocessed logs' do
      before do
        create_list(:log, 5, input: 'Test Input 4', is_processed: false)
      end

      it 'does not include unprocessed logs' do
        result = Log.top_five_inputs
        expect(result).to be_empty
      end
    end

    context 'when there are both processed and unprocessed logs' do
      before do
        create_list(:log, 3, input: 'Test Input 1', is_processed: true)
        create_list(:log, 2, input: 'Test Input 2', is_processed: true)
        create_list(:log, 1, input: 'Test Input 3', is_processed: true)
        create_list(:log, 5, input: 'Test Input 4', is_processed: false)
      end

      it 'only includes processed logs in the result' do
        result = Log.top_five_inputs
        expect(result.map(&:input)).to eq(['Test Input 1', 'Test Input 2', 'Test Input 3'])
      end
    end
  end
end
