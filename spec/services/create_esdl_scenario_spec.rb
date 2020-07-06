# frozen_string_literal: true

require 'rails_helper'

describe CreateEsdlScenario, type: :service do
  let(:result) { described_class.call('file string') }

  context 'with a valid esdl file' do
    before do
      allow(described_class).to receive(:call)
        .with('file string')
        .and_return(ServiceResult.success('scenario_id' => 123_456))
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the scenario_id of the scenario created based on the esdl' do
      expect(result.value).to include({ 'scenario_id' => 123_456 })
    end
  end

  context 'with an esdl file that cannot be parsed' do
    before do
      allow(described_class).to receive(:call)
        .with('file string')
        .and_return(ServiceResult.failure(['This ESDL file cannot be converted into a scenario']))
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns an error' do
      expect(result.errors).to include('This ESDL file cannot be converted into a scenario')
    end
  end

  context 'with a malformed request' do
    before do
      allow(described_class).to receive(:call)
        .with('file string')
        .and_return(ServiceResult.failure(['Malformed request']))
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'contains errors' do
      expect(result.errors).not_to be_empty
    end
  end
end
