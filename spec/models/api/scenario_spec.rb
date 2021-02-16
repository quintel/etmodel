# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Scenario, vcr: true do
  let(:scenario) { described_class.find(648_696) }

  describe '#created_at' do
    it 'parses the value as a Time' do
      expect(scenario.created_at).to eq(Time.utc(2017, 3, 13, 19, 22, 55))
    end

    it 'sets the timezone to UTC' do
      expect(scenario.created_at.zone).to eq('UTC')
    end
  end

  describe '#updated_at' do
    it 'parses the value as a Time' do
      expect(scenario.updated_at).to eq(Time.utc(2019, 5, 8, 14, 15, 24))
    end

    it 'sets the timezone to UTC' do
      expect(scenario.updated_at.zone).to eq('UTC')
    end
  end
end
