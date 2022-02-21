# frozen_string_literal: true

require 'rails_helper'

describe UnprotectApiScenario, type: :service do
  context 'when the response is successful' do
    before do
      allow(HTTParty).to receive(:put).with(
        %r{/api/v3/scenarios/1}, body: { scenario: { protected: false } }
      ).and_return(ServicesHelper::StubResponse.new(true, {}))
    end

    it 'returns a successful result' do
      expect(described_class.call(1)).to be_successful
    end

    it 'sends a request to unprotect the scenario' do
      described_class.call(1)

      expect(HTTParty).to have_received(:put).with(
        %r{/api/v3/scenarios/1}, body: { scenario: { protected: false } }
      )
    end
  end

  context 'when the response is unsuccessful' do
    before do
      allow(HTTParty).to receive(:put).with(
        %r{/api/v3/scenarios/1}, body: { scenario: { protected: false } }
      ).and_return(
        ServicesHelper::StubResponse.new(false, 'errors' => ['Oops!'])
      )
    end

    it 'returns a failure result' do
      expect(described_class.call(1)).not_to be_successful
    end

    it 'sends a request to unprotect the scenario' do
      described_class.call(1)

      expect(HTTParty).to have_received(:put).with(
        %r{/api/v3/scenarios/1}, body: { scenario: { protected: false } }
      )
    end

    it 'includes the errors on the result' do
      expect(described_class.call(1).errors).to eq(['Oops!'])
    end
  end
end
