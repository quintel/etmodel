# frozen_string_literal: true

require 'rails_helper'

describe MyEtm::FeaturedScenario do
  describe 'attributes' do
    let(:valid_attributes) do
      {
        id: 1,
        saved_scenario_id: 42,
        owner_id: nil,
        group: nil,
        title_en: 'English Title',
        title_nl: 'Dutch Title',
        version: '1.0',
        end_year: 2050,
        author: 'Author'
      }
    end

    it 'can be instantiated with valid attributes' do
      scenario = described_class.new(valid_attributes)
      expect(scenario.id).to eq(1)
      expect(scenario.saved_scenario_id).to eq(42)
      expect(scenario.owner_id).to be_nil
      expect(scenario.group).to be_nil
      expect(scenario.title_en).to eq('English Title')
      expect(scenario.title_nl).to eq('Dutch Title')
      expect(scenario.version).to eq('1.0')
      expect(scenario.end_year).to eq(2050)
      expect(scenario.author).to eq('Author')
    end

    it 'raises an error when required attributes are missing or invalid' do
      expect {
        described_class.new(valid_attributes.except(:id))
      }.to raise_error(Dry::Struct::Error)

      expect {
        described_class.new(valid_attributes.merge(id: 'invalid'))
      }.to raise_error(Dry::Struct::Error)
    end
  end

  describe '.in_groups_per_end_year' do
    let(:scenarios) do
      [
        described_class.new(id: 1, saved_scenario_id: 10, owner_id: nil, group: 'group1', title_en: 'Scenario 1 EN', title_nl: 'Scenario 1 NL', version: '1.0', end_year: 2050, author: 'Author 1'),
        described_class.new(id: 2, saved_scenario_id: 20, owner_id: 1, group: 'group1', title_en: 'Scenario 2 EN', title_nl: 'Scenario 2 NL', version: '1.0', end_year: 2050, author: 'Author 2'),
        described_class.new(id: 3, saved_scenario_id: 30, owner_id: nil, group: 'group2', title_en: 'Scenario 3 EN', title_nl: 'Scenario 3 NL', version: '2.0', end_year: 2040, author: 'Author 3')
      ]
    end

    it 'groups scenarios by end year and then by group' do
      result = described_class.in_groups_per_end_year(scenarios)

      expect(result.keys).to match_array([2050, 2040])

      expect(result[2050]).to match_array([
        { name: 'group1', scenarios: [scenarios[0], scenarios[1]] }
      ])

      expect(result[2040]).to match_array([
        { name: 'group2', scenarios: [scenarios[2]] }
      ])
    end
  end

  describe '#localized_title' do
    let(:scenario) do
      described_class.new(id: 1, saved_scenario_id: 10, owner_id: nil, group: nil, title_en: 'English Title', title_nl: 'Dutch Title', version: '1.0', end_year: 2050, author: 'Author')
    end

    it 'returns the Dutch title when locale is :nl' do
      expect(scenario.localized_title(:nl)).to eq('Dutch Title')
    end

    it 'returns the English title when locale is not :nl' do
      expect(scenario.localized_title(:en)).to eq('English Title')
      expect(scenario.localized_title(:fr)).to eq('English Title')
    end
  end
end
