# frozen_string_literal: true

require 'rails_helper'

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

    context 'with saved_scenario_users' do
      it 'converts role strings to integers' do
        params = {
          title: 'Test Scenario',
          area_code: 'nl',
          end_year: 2050,
          scenario_id: 1234,
          saved_scenario_users: [
            { user_id: 1, role: 'scenario_collaborator' },
            { user_id: 2, role: 'scenario_viewer' },
            { user_id: 3, role: 'scenario_owner' }
          ]
        }

        scenario = described_class.from_params(params)

        expect(scenario.saved_scenario_users.length).to eq(3)
        expect(scenario.saved_scenario_users[0].id).to eq(1)
        expect(scenario.saved_scenario_users[0].role).to eq(2)
        expect(scenario.saved_scenario_users[1].id).to eq(2)
        expect(scenario.saved_scenario_users[1].role).to eq(1)
        expect(scenario.saved_scenario_users[2].id).to eq(3)
        expect(scenario.saved_scenario_users[2].role).to eq(3)
      end

      it 'returns role 0 for unknown role strings' do
        params = {
          title: 'Test Scenario',
          area_code: 'nl',
          end_year: 2050,
          scenario_id: 1234,
          saved_scenario_users: [
            { user_id: 1, role: 'unknown_role' }
          ]
        }

        scenario = described_class.from_params(params)

        expect(scenario.saved_scenario_users[0].role).to eq(0)
      end
    end
  end

  describe '.role_to_int' do
    it 'converts scenario_viewer to 1' do
      expect(described_class.role_to_int('scenario_viewer')).to eq(1)
    end

    it 'converts scenario_collaborator to 2' do
      expect(described_class.role_to_int('scenario_collaborator')).to eq(2)
    end

    it 'converts scenario_owner to 3' do
      expect(described_class.role_to_int('scenario_owner')).to eq(3)
    end

    it 'returns 0 for unknown roles' do
      expect(described_class.role_to_int('unknown')).to eq(0)
    end

    it 'returns 0 for non-prefixed role names' do
      expect(described_class.role_to_int('viewer')).to eq(0)
      expect(described_class.role_to_int('collaborator')).to eq(0)
      expect(described_class.role_to_int('owner')).to eq(0)
    end

    it 'handles different casings' do
      expect(described_class.role_to_int('SCENARIO_COLLABORATOR')).to eq(2)
      expect(described_class.role_to_int('Scenario_Viewer')).to eq(1)
    end

    it 'handles whitespace' do
      expect(described_class.role_to_int('  scenario_collaborator  ')).to eq(2)
    end
  end

  describe '#collaborator?' do
    let(:user) { double('User', id: 1) }

    it 'returns true when user is a collaborator' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_collaborator' }
        ]
      )

      expect(scenario.collaborator?(user)).to be true
    end

    it 'returns true when user is an owner' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_owner' }
        ]
      )

      expect(scenario.collaborator?(user)).to be true
    end

    it 'returns false when user is only a viewer' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_viewer' }
        ]
      )

      expect(scenario.collaborator?(user)).to be false
    end

    it 'returns false when user is not in the saved_scenario_users list' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 2, role: 'scenario_collaborator' }
        ]
      )

      expect(scenario.collaborator?(user)).to be false
    end
  end

  describe '#viewer?' do
    let(:user) { double('User', id: 1) }

    it 'returns true when user is a viewer' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_viewer' }
        ]
      )

      expect(scenario.viewer?(user)).to be true
    end

    it 'returns true when user is a collaborator (has viewer permissions)' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_collaborator' }
        ]
      )

      expect(scenario.viewer?(user)).to be true
    end

    it 'returns true when user is an owner (has viewer permissions)' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 1, role: 'scenario_owner' }
        ]
      )

      expect(scenario.viewer?(user)).to be true
    end

    it 'returns false when user is not in the saved_scenario_users list' do
      scenario = described_class.from_params(
        title: 'Test',
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1234,
        saved_scenario_users: [
          { user_id: 2, role: 'scenario_viewer' }
        ]
      )

      expect(scenario.viewer?(user)).to be false
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
