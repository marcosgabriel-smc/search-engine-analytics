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

    it 'is invalid without a city' do
      log = build(:log, city: nil)
      expect(log).not_to be_valid
      expect(log.errors[:city]).to include("can't be blank")
    end

    it 'is invalid without a country' do
      log = build(:log, country: nil)
      expect(log).not_to be_valid
      expect(log.errors[:country]).to include("can't be blank")
    end
  end
end
