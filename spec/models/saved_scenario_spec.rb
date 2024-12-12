# frozen_string_literal: true

require 'dry-struct'
require 'active_model'
require 'spec_helper'

RSpec.describe SavedScenario do
  describe 'attributes' do
    let(:valid_attributes) do
      {
        title: 'My Saved Scenario',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234
      }
    end

    it 'can be instantiated with valid attributes' do
      scenario = described_class.new(valid_attributes)
      expect(scenario.title).to eq('My Saved Scenario')
      expect(scenario.area_code).to eq('nl')
      expect(scenario.end_year).to eq(2050)
      expect(scenario.scenario_id).to eq(1234)
    end

    it 'raises an error when required attributes are missing or invalid' do
      expect {
        described_class.new(valid_attributes.except(:title))
      }.to raise_error(Dry::Struct::Error)

      expect {
        described_class.new(valid_attributes.merge(end_year: 'invalid'))
      }.to raise_error(Dry::Struct::Error)
    end
  end

  describe '.from_params' do
    it 'creates a new instance with symbolized keys from params' do
      params = ActionController::Parameters.new(
        'title' => 'My Saved Scenario',
        'area_code' => 'nl',
        'end_year' => 2050,
        'scenario_id' => 1234
      ).permit(:title, :area_code, :end_year, :scenario_id)

      scenario = described_class.from_params(params)
      expect(scenario).to be_an_instance_of(described_class)
      expect(scenario.title).to eq('My Saved Scenario')
      expect(scenario.area_code).to eq('nl')
      expect(scenario.end_year).to eq(2050)
      expect(scenario.scenario_id).to eq(1234)
    end
  end

  describe 'ActiveModel compliance' do
    let(:scenario) { described_class.new(title: 'Scenario', area_code: 'nl', end_year: 2050, scenario_id: 1234) }

    it 'responds to persisted? and is false' do
      expect(scenario.persisted?).to be(false)
    end

    it 'responds to valid? and is true when there are no errors' do
      expect(scenario.valid?).to be(true)
    end

    it 'allows adding errors' do
      scenario.errors.add(:title, 'cannot be blank')
      expect(scenario.errors[:title]).to include('cannot be blank')
      expect(scenario.valid?).to be(false)
    end

    it 'works with form_for' do
      expect(scenario).to respond_to(:to_model)
      expect(scenario).to respond_to(:model_name)
      expect(scenario.model_name).to eq('SavedScenario')
    end
  end
end
