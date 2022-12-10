# frozen_string_literal: true

require 'rails_helper'

describe CreateMultiYearChart, type: :service do
  let(:scenario) { FactoryBot.build(:saved_scenario, scenario_id: 1) }
  let(:user) { FactoryBot.create(:user) }
  let(:result) { described_class.call(scenario, user, years) }

  # --

  def stub_successful_interpolation(year, id)
    allow(InterpolateAPIScenario).to receive(:call)
      .with(scenario.scenario_id, year, keep_compatible: true)
      .and_return(ServiceResult.success('id' => id))
  end

  def stub_failed_interpolation(year, errors)
    allow(InterpolateAPIScenario).to receive(:call)
      .with(scenario.scenario_id, year, keep_compatible: true)
      .and_return(ServiceResult.failure(errors))
  end

  # --

  context 'when creating scenarios for 2030, 2040' do
    let(:years) { [2030, 2040] }

    context 'when the interpolation is successful' do
      before do
        stub_successful_interpolation(2030, 2)
        stub_successful_interpolation(2040, 3)
        stub_successful_interpolation(2050, 4)
      end

      it 'returns a ServiceResult' do
        expect(result).to be_a(ServiceResult)
      end

      it 'is successful' do
        expect(result).to be_successful
      end

      it 'creates a MultiYearChart record' do
        expect(result.value).to be_persisted
      end

      it 'creates three MultiYearChartScenario records' do
        # The two original scenarios, plus the original.
        expect { result }
          .to change(MultiYearChartScenario, :count).by(3)
      end

      it 'associates the scenarios with the MultiYearChart' do
        expect(result.value.scenarios.count).to be(3)
      end
    end

    context 'when ETEngine returns an error for 2030, but not 2040' do
      before do
        stub_failed_interpolation(2030, ["That didn't work."])
        # 2040 and 2050 requests are never made.
      end

      it 'returns a ServiceResult' do
        expect(result).to be_a(ServiceResult)
      end

      it 'is not successful' do
        expect(result).not_to be_successful
      end

      it 'does not unprotect any scenarios' do
        # Service should stop immediately after the 2030 scenario, and not
        # attempt to create any more.
        allow(SetAPIScenarioCompatibility).to receive(:dont_keep_compatible)

        result
        expect(SetAPIScenarioCompatibility).not_to have_received(:dont_keep_compatible)
      end

      it 'includes the errors on the Result' do
        expect(result.errors).to eq(["That didn't work."])
      end

      it 'does not create a MultiYearChart record' do
        expect { result }.not_to change(MultiYearChart, :count)
      end

      it 'does not create any MultiYearChartScenario records' do
        expect { result }.not_to change(MultiYearChartScenario, :count)
      end
    end

    context 'when ETEngine succeeds for 2030 but not 2040' do
      before do
        stub_successful_interpolation(2030, 2)
        stub_failed_interpolation(2040, ["That didn't work."])

        allow(SetAPIScenarioCompatibility).to receive(:dont_keep_compatible).with(2)
      end

      it 'is not successful' do
        expect(result).not_to be_successful
      end

      it 'unprotects the successful 2030 scenario' do
        result
        expect(SetAPIScenarioCompatibility).to have_received(:dont_keep_compatible).with(2)
      end

      it 'does not create any MultiYearChartScenario records' do
        expect { result }.not_to change(MultiYearChartScenario, :count)
      end
    end

    context 'when ETEngine returns an error for 2030 and 2040' do
      before do
        stub_failed_interpolation(2030, ["That didn't work."])
        # 2040 and 2050 requests are never made.
      end

      it 'is not successful' do
        expect(result).not_to be_successful
      end

      it 'does not unprotect any scenarios' do
        allow(SetAPIScenarioCompatibility).to receive(:dont_keep_compatible)
        result
        expect(SetAPIScenarioCompatibility).not_to have_received(:dont_keep_compatible)
      end

      it 'includes the errors on the Result' do
        expect(result.errors).to eq(["That didn't work."])
      end

      it 'does not create a MultiYearChart record' do
        expect { result }.not_to change(MultiYearChart, :count)
      end

      it 'does not create any MultiYearChartScenario records' do
        expect { result }.not_to change(MultiYearChartScenario, :count)
      end
    end
  end

  # Sanity check that invalid records raise exceptions.
  context 'when given an invalid user, creating a 2030 scenario' do
    let(:user) { User.new }
    let(:years) { [2030] }

    before do
      stub_successful_interpolation(2030, 2)
      stub_successful_interpolation(2050, 3)
      allow(SetAPIScenarioCompatibility).to receive(:dont_keep_compatible).with(2)
      allow(SetAPIScenarioCompatibility).to receive(:dont_keep_compatible).with(3)
    end

    it 'raises the error' do
      expect { result }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'unprotects the 2030 scenario' do
      begin
        result
      rescue ActiveRecord::RecordInvalid
        nil
      end

      expect(SetAPIScenarioCompatibility).to have_received(:dont_keep_compatible).with(2)
    end

    it 'unprotects the 2050 scenario' do
      begin
        result
      rescue ActiveRecord::RecordInvalid
        nil
      end

      expect(SetAPIScenarioCompatibility).to have_received(:dont_keep_compatible).with(3)
    end
  end
end
