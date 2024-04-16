require 'rails_helper'

describe FetchSavedScenarioVersionTags, type: :service do
  let(:result) { described_class.call(client, saved_scenario) }
  let(:saved_scenario) { create(:saved_scenario, scenario_id: 123, scenario_id_history: [111, 122])}

  let(:response_data) do
    {
      '123' => {
        'id' => 2,
        'user_id' => 245,
        'description'  => 'added some buildings',
        'last_updated_at' => 2.hours.ago.to_json
      },
      '111' => {
        'last_updated_at' =>  2.days.ago.to_json
      },
      '122' => {
        'id' => 1,
        'user_id' => 245,
        'description' => 'adjusted wind turbines',
        'last_updated_at' =>  1.day.ago.to_json
      }
    }
  end

  context 'when the response contains data for the versions' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/versions') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              response_data
            ]
          end
        end
      end
    end

    it 'returns a success' do
      expect(result).to be_successful
    end
  end
end
