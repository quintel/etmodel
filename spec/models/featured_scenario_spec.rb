# frozen_string_literal: true

require 'rails_helper'

describe MyEtm::FeaturedScenario do
  def featured_scenario(group='group1', year=2050)
    described_class.new(
      id: 1,
      saved_scenario_id: 42,
      owner_id: nil,
      group: group,
      title_en: 'English Title',
      title_nl: 'Dutch Title',
      version: '1.0',
      end_year: year,
      area_code: 'nl2019',
      author: 'Author'
    )
  end
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
        area_code: 'nl2019',
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
        featured_scenario('group1'),
        featured_scenario('group1'),
        featured_scenario('group2', 2040)
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
      featured_scenario
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
