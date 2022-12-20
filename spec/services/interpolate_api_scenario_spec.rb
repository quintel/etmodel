# frozen_string_literal: true

require 'rails_helper'

describe InterpolateAPIScenario, type: :service do
  # let(:scenario) { FactoryBot.build(:api_scenario, id: 1) }
  let(:user) { create(:user) }
  let(:client) { instance_double(Faraday::Connection) }
  let(:result) { described_class.call(client, 1, 2030, keep_compatible:) }
  let(:keep_compatible) { false }

  # --

  # Returns a Struct which quacks enough like an HTTParty::Response for our
  # purposes.
  def stub_response(client, isok, body, keep_compatible = false)
    stub = allow(client)
      .to receive(:post)
      .with(
        '/api/v3/scenarios/1/interpolate',
        scenario: { end_year: 2030, keep_compatible: }
      )

    if isok
      stub.and_return(ServicesHelper::StubResponse.new(isok, body))
    else
      stub.and_raise(stub_faraday_422(body))
    end
  end

  def stub_ok_response(client, id, keep_compatible)
    stub_response(client, true, { 'id' => id }, keep_compatible)
  end

  def stub_error_response(client, errors)
    stub_response(client, false, errors, false)
  end

  # --

  context 'when the interpolation is successful' do
    before do
      stub_ok_response(client, 2, keep_compatible)
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the JSON response' do
      expect(result.value['id']).to eq(2)
    end

    it 'sends a request to ETEngine' do
      result

      expect(client).to have_received(:post)
        .with('/api/v3/scenarios/1/interpolate', anything)
    end

    it 'sends the desired end year to ETEngine' do
      result

      expect(client).to have_received(:post).with(
        '/api/v3/scenarios/1/interpolate',
        scenario: { end_year: 2030, keep_compatible: false }
      )
    end

    context 'when marking the scenario keep_compatible' do
      let(:keep_compatible) { true }

      it 'tells ETEngine to protect the scenario' do
        result

        expect(client).to have_received(:post).with(
          '/api/v3/scenarios/1/interpolate',
          scenario: { end_year: 2030, keep_compatible: true }
        )
      end
    end
  end

  context 'when the interpolation fails' do
    before do
      stub_error_response(client, ["That didn't work."])
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'includes the errors on the Result' do
      expect(result.errors).to eq(["That didn't work."])
    end
  end
end
