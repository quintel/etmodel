# frozen_string_literal: true

require 'rails_helper'

describe SavedScenarioHistoryPresenter do
  subject { described_class.present(saved_scenario, api_response) }

  let(:api_response) do
    {
      '123' => {
        'id' => 2,
        'user_id' => user.id,
        'description'  => 'added some buildings',
        'last_updated_at' => 2.hours.ago.to_json
      },
      '111' => {
        'last_updated_at' =>  2.days.ago.to_json
      },
      '122' => {
        'id' => 1,
        'user_id' => user.id,
        'description' => 'adjusted wind turbines',
        'last_updated_at' =>  1.day.ago.to_json
      }
    }
  end

  let(:user) { create(:user) }
  let(:saved_scenario) { create(:saved_scenario, scenario_id: 123, scenario_id_history: [111, 122]) }

  it 'returns the versions sorted from current to last' do
    expect(subject.map { |v| v['scenario_id'] }).to eq([123, 122, 111])
  end

  it 'subsitutes the user id for a users name' do
    expect(subject.first).to include({ 'user' => user.name })
  end

  it 'removes the user id' do
    expect(subject.first.keys).not_to include('user_id')
  end

  it 'sets a "unknown" name when no user was known for the version (older scenario compatability)' do
    expect(subject.last.keys).to include('user')
  end
end
