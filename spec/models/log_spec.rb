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

  describe '.latest_logs' do
    context 'when there are processed logs' do
      before do
        @log1 = create(:log, is_processed: true, created_at: 1.day.ago)
        @log2 = create(:log, is_processed: true, created_at: 2.days.ago)
        @log3 = create(:log, is_processed: true, created_at: 3.days.ago)
      end

      it 'returns the latest logs in descending order' do
        result = Log.latest_logs
        expect(result).to eq([@log1, @log2, @log3])
      end
    end

    context 'when there are no processed logs' do
      it 'returns an empty array' do
        result = Log.latest_logs
        expect(result).to be_empty
      end
    end
  end

  describe '.top_users' do
    context 'when there are processed logs' do
      before do
        create_list(:log, 3, ip: '192.168.0.1', is_processed: true)
        create_list(:log, 2, ip: '192.168.0.2', is_processed: true)
        create_list(:log, 1, ip: '192.168.0.3', is_processed: true)
      end

      it 'returns the top users by log count' do
        result = Log.top_users
        expect(result.keys).to include('192.168.0.1', '192.168.0.2', '192.168.0.3')
      end
    end

    context 'when there are no processed logs' do
      it 'returns an empty hash' do
        result = Log.top_users
        expect(result).to be_empty
      end
    end
  end

  describe '.logs_by_country' do
    context 'when there are processed logs' do
      before do
        create_list(:log, 3, country: 'USA', is_processed: true)
        create_list(:log, 2, country: 'Canada', is_processed: true)
        create_list(:log, 1, country: 'Mexico', is_processed: true)
      end

      it 'returns the log count grouped by country' do
        result = Log.logs_by_country
        expect(result).to eq({ 'USA' => 3, 'Canada' => 2, 'Mexico' => 1 })
      end
    end

    context 'when there are no processed logs' do
      it 'returns an empty hash' do
        result = Log.logs_by_country
        expect(result).to be_empty
      end
    end
  end

  describe '.perform_log_processing' do
    before do
      base_time = Time.now - 3.hours
      final_string = 'All the query'

      @logs = (1..final_string.length).map do |i|
        Log.create!(
          ip: '192.168.1.1',
          input: "XXX - #{final_string[0, i]}",
          country: "Brazil",
          is_processed: false,
          created_at: base_time - (final_string.length - i).minutes
        )
      end

      @different_log = Log.create(ip: '192.168.1.1', input: 'This is all different', country: "Brazil", is_processed: false, created_at: 1.minute.ago)

      @same_input = Log.create(ip: '192.168.1.2', input: 'This is the Whole Query!', country: "Brazil", is_processed: false, created_at: 1.hour.ago)
      @same_input2 = Log.create(ip: '192.168.1.3', input: 'This is the Whole Query!', country: "Brazil", is_processed: false, created_at: 1.hour.ago)

      @single_log = Log.create(ip: '192.168.1.4', input: 'Only one query', country: "Brazil", is_processed: false)
    end

    it 'marks only the last log of a long query as processed' do
      Log.perform_log_processing
      processed_logs = Log.where(is_processed: true)
      expect(processed_logs.last.is_processed).to be true
    end

    it 'deletes the unprocessed logs' do
      Log.perform_log_processing
      expect(Log.where(is_processed: false)).to be_empty
    end

    it 'marks both queries as processed when they start with the same characters but then differ in the end' do
      recorded_logs = [@logs.last.id, @different_log.id]
      Log.perform_log_processing
      processed_logs = Log.where(id: recorded_logs)
      processed_logs.each do |log|
        expect(log.is_processed).to be true
      end
    end

    it 'marks queries from different users with the same input as processed' do
      recorded_logs = [@same_input.id, @same_input2.id]
      Log.perform_log_processing
      processed_logs = Log.where(id: recorded_logs)
      processed_logs.each do |log|
        expect(log.is_processed).to be true
      end
    end

    it 'marks a single query as processed' do
      recorded_logs = @single_log.id
      Log.perform_log_processing
      processed_logs = Log.where(id: recorded_logs)
      processed_logs.each do |log|
        expect(log.is_processed).to be true
      end
    end
  end
end
