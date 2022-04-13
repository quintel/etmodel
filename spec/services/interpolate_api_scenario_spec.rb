# frozen_string_literal: true

require 'rails_helper'

describe InterpolateApiScenario, type: :service do
  # let(:scenario) { FactoryBot.build(:api_scenario, id: 1) }
  let(:user) { FactoryBot.create(:user) }
  let(:result) { described_class.call(1, 2030, keep_compatible: keep_compatible) }
  let(:keep_compatible) { false }

  # --

  # Returns a Struct which quacks enough like an HTTParty::Response for our
  # purposes.
  def stub_response(isok, body, keep_compatible = false)
    allow(HTTParty)
      .to receive(:post)
      .with(
        "#{Settings.api_url}/api/v3/scenarios/1/interpolate",
        hash_including(body: { end_year: 2030, keep_compatible: }.to_json)
      )
      .and_return(ServicesHelper::StubResponse.new(isok, body))
  end

  def stub_ok_response(id, keep_compatible)
    stub_response(true, { 'id' => id }, keep_compatible)
  end

  def stub_error_response(errors)
    stub_response(false, { 'errors' => errors }, false)
  end

  # --

  context 'when the interpolation is successful' do
    before do
      stub_ok_response(2, keep_compatible)
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

      expect(HTTParty).to have_received(:post)
        .with(%r{/api/v3/scenarios/1/interpolate}, anything)
    end

    it 'sends the desired end year to ETEngine' do
      result

      expect(HTTParty).to have_received(:post).with(
        anything,
        hash_including(body: { end_year: 2030, keep_compatible: false }.to_json)
      )
    end

    context 'when marking the scenario keep_compatible' do
      let(:keep_compatible) { true }

      it 'tells ETEngine to protect the scenario' do
        result

        expect(HTTParty).to have_received(:post).with(
          anything,
          hash_including(body: { end_year: 2030, keep_compatible: true }.to_json)
        )
      end
    end
  end

  context 'when the interpolation fails' do
    before do
      stub_error_response(["That didn't work."])
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
