# frozen_string_literal: true

require 'rails_helper'

describe SetAPIScenarioCompatibility, type: :service do
  let(:client) { instance_double(Faraday::Connection) }

  context 'when the response is successful' do
    before do
      allow(client).to receive(:put).with(
        '/api/v3/scenarios/1', scenario: { keep_compatible: false }
      )
    end

    it 'returns a successful result' do
      expect(described_class.call(client, 1, false)).to be_successful
    end

    describe '#keep_compatible' do
      before do
        allow(client).to receive(:put).with(
          '/api/v3/scenarios/1', scenario: { keep_compatible: true }
        )
      end

      it 'sends a request to unprotect the scenario' do
        described_class.keep_compatible(client, 1)

        expect(client).to have_received(:put).with(
          '/api/v3/scenarios/1', scenario: { keep_compatible: true }
        )
      end
    end

    describe '#dont_keep_compatible' do
      before do
        allow(client).to receive(:put).with(
          '/api/v3/scenarios/1', scenario: { keep_compatible: false }
        )
      end

      it 'sends a request to unprotect the scenario' do
        described_class.dont_keep_compatible(client, 1)

        expect(client).to have_received(:put).with(
          '/api/v3/scenarios/1', scenario: { keep_compatible: false }
        )
      end
    end
  end

  context 'when the response is unsuccessful' do
    before do
      allow(client).to receive(:put).with(
        '/api/v3/scenarios/1', scenario: { keep_compatible: false }
      ).and_raise(stub_faraday_422(['Oops!']))
    end

    it 'returns a failure result' do
      expect(described_class.call(client, 1, false)).not_to be_successful
    end

    it 'sends a request to ETEngine' do
      described_class.call(client, 1, false)

      expect(client).to have_received(:put).with(
        '/api/v3/scenarios/1', scenario: { keep_compatible: false }
      )
    end

    it 'includes the errors on the result' do
      expect(described_class.call(client, 1, false).errors).to eq(['Oops!'])
    end
  end
end
