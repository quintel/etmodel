# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::UpdateTransitionPath do
  let(:user) { create(:user) }
  let(:result) { described_class.new.call(transition_path:, params:) }

  let(:transition_path) do
    create(
      :multi_year_chart,
      title: 'Original title',
      area_code: 'nl',
      end_year: 2040
    )
  end

  let(:params) do
    {
      title: 'New title',
      area_code: 'nl2019',
      end_year: 2050
    }
  end

  context 'with valid parameters, without scenario IDs' do
    it 'returns a success' do
      expect(result).to be_success
    end

    it 'returns the transition path' do
      expect(result.value!).to be_a(MultiYearChart)
    end

    it 'updates the transition path' do
      expect(result.value!.attributes).to include(
        'title' => 'New title',
        'area_code' => 'nl2019',
        'end_year' => 2050
      )
    end

    it 'leaves the scenario IDs unchanged' do
      expect { result }.not_to(change { transition_path.scenarios.map(&:scenario_id).sort })
    end
  end

  context 'with all-new scenario IDs' do
    let(:params) do
      { scenario_ids: [1000, 2000, 3000] }
    end

    it 'returns a success' do
      expect(result).to be_success
    end

    it 'returns the transition path' do
      expect(result.value!).to be_a(MultiYearChart)
    end

    it 'updates the scenario_ids' do
      expect(result.value!.reload.scenarios.map(&:scenario_id).sort).to eq([1000, 2000, 3000])
    end
  end

  context 'with some new scenario IDs' do
    let(:original_scenario_ids) { transition_path.scenarios.pluck(:scenario_id) }

    let(:params) do
      { scenario_ids: original_scenario_ids + [original_scenario_ids.last + 1] }
    end

    it 'returns a success' do
      expect(result).to be_success
    end

    it 'returns the transition path' do
      expect(result.value!).to be_a(MultiYearChart)
    end

    it 'updates the scenario_ids' do
      expect(result.value!.scenarios.map(&:scenario_id).sort).to eq(
        original_scenario_ids + [original_scenario_ids.last + 1]
      )
    end
  end

  context 'with invalid parameters' do
    let(:params) do
      {
        title: '',
        area_code: '',
        end_year: '',
        scenario_ids: []
      }
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'returns the errors' do
      expect(result.failure).to eq({
        title: ['must be filled'],
        area_code: ['must be filled'],
        end_year: ['must be an integer'],
        scenario_ids: ['must be filled']
      })
    end
  end

  context 'with non-numeric scenario IDs' do
    let(:params) do
      super().merge(scenario_ids: [nil, 'nope', -1])
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'returns the errors' do
      expect(result.failure).to eq({
        scenario_ids: {
          0 => ['must be an integer'],
          1 => ['must be an integer'],
          2 => ['must be greater than 0']
        }
      })
    end
  end

  context 'when given more than 100 scenario IDs' do
    let(:params) do
      super().merge(scenario_ids: (1..101).to_a)
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'returns the errors' do
      expect(result.failure).to eq({
        scenario_ids: ['size cannot be greater than 100']
      })
    end
  end

  context 'with valid params, but duplicate scenario IDs' do
    let(:params) do
      super().merge(scenario_ids: [10, 10, 20])
    end

    it 'returns a success' do
      expect(result).to be_success
    end

    it 'creates the transition path' do
      expect(result.value!).to be_a(MultiYearChart)
    end

    it 'creates the scenarios for the transition path, ignoring duplicates' do
      expect(result.value!.scenarios.map(&:scenario_id).sort).to eq([10, 20])
    end
  end
end
