# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateSavedScenario do
  let(:client) { instance_double(Faraday::Connection) }
  let(:service) { described_class.new(client, saved_scenario_id, scenario_id) }
  let(:saved_scenario_id) { 123 }
  let(:scenario_id) { 456 }

  describe '#call' do
    subject { service.call }

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
        subject

        expect(client).to have_received(:put).with("api/v1/saved_scenarios/#{saved_scenario_id}")
      end

      it 'parses the scenario id' do
        subject

        expect(request_double).to have_received(:body=).with({ scenario_id: scenario_id }.to_json)
      end

      it { is_expected.to be_successful }

      it 'returns a successful ServiceResult' do
        expect(subject.value).to eq(response.body)
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

      it { is_expected.to be_failure }

      it 'rescues the error and returns a failure ServiceResult' do
        expect(subject.errors).to include('Some error')
      end
    end

    [Faraday::ResourceNotFound, Faraday::ForbiddenError].each do |refusal|
      context "when MyETM refuses the save with #{refusal.name.demodulize}" do
        before do
          allow(client).to receive(:put).and_raise(refusal.new('Refused'))
          allow(Sentry).to receive(:capture_exception)
        end

        it { is_expected.to be_failure }

        it 'reports nothing to Sentry' do
          subject

          expect(Sentry).not_to have_received(:capture_exception)
        end
      end
    end

    context 'when MyETM fails' do
      before do
        allow(client).to receive(:put).and_raise(Faraday::ServerError.new('Down'))
        allow(Sentry).to receive(:capture_exception)
      end

      it { is_expected.to be_failure }

      it 'reports the error to Sentry' do
        subject

        expect(Sentry).to have_received(:capture_exception)
      end
    end

    context 'when another error occurs during the API call' do
      let(:error) { StandardError.new('Some other error') }

      before do
        allow(client).to receive(:put).and_raise(error)
      end

      it 'raises the error' do
        expect { subject }.to raise_error(StandardError, 'Some other error')
      end
    end
  end
end
