# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateSavedScenario do
  let(:client) { instance_double(Faraday::Connection) }
  let(:service) { described_class.new(client, saved_scenario_id, scenario_id) }
  let(:saved_scenario_id) { 123 }
  let(:scenario_id) { 456 }

  describe '#call' do
    subject(:call_service) { service.call }

    let(:response) { instance_double('Faraday::Response', body: { 'data' => 'response_data' }.to_json) }

    context 'when the API call is successful' do
      let(:request_double) { instance_double('Faraday::Request') }

      before do
        allow(client).to receive(:put).with("api/v1/saved_scenarios/#{saved_scenario_id}")
          .and_yield(request_double)
          .and_return(response)

        allow(request_double).to receive(:headers).and_return({})
        allow(request_double).to receive(:body=)
      end

      it 'makes a PUT request to update the saved scenario' do
        call_service
        expect(client).to have_received(:put).with("api/v1/saved_scenarios/#{saved_scenario_id}")
        expect(request_double).to have_received(:body=).with({ scenario_id: scenario_id }.to_json)
      end

      it 'returns a successful ServiceResult' do
        result = call_service
        expect(result).to be_successful
        expect(result.value).to eq(response.body)
      end
    end

    context 'when the API call returns an unprocessable entity error' do
      let(:error) do
        Faraday::UnprocessableEntityError.new('Unprocessable Entity').tap do |e|
          allow(e).to receive(:response).and_return({ body: { 'errors' => ['Some error'] } })
        end
      end

      before do
        allow(client).to receive(:put).and_raise(error)
      end

      it 'rescues the error and returns a failure ServiceResult' do
        result = call_service
        expect(result).to be_failure
        expect(result.errors).to include('Some error')
      end
    end

    context 'when another error occurs during the API call' do
      let(:error) { StandardError.new('Some other error') }

      before do
        allow(client).to receive(:put).and_raise(error)
      end

      it 'raises the error' do
        expect { call_service }.to raise_error(StandardError, 'Some other error')
      end
    end
  end
end
