# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSavedScenario, type: :service do
  let(:client) { instance_double(Faraday::Connection) }
  let(:service) { described_class.new(client, scenario_id, settings) }
  let(:settings) { { title: 'My scenario' } }
  let(:scenario_id) { 456 }

  describe '#call' do
    subject { service.call }

    let(:response) do
      instance_double('Faraday::Response', body: { 'saved_scenario_id' => '30' }.to_json)
    end

    before do
      allow(client).to receive(:post).with(
        'api/v1/saved_scenarios'
      ).and_return(response)
    end

    context 'when the API call is successful' do
      it { is_expected.to be_successful }

      it 'makes a POST request to update the saved scenario' do
        subject
        expect(client).to have_received(:post).with("api/v1/saved_scenarios")
      end

      it 'returns a successful ServiceResult' do
        expect(subject.value).to eq(response.body)
      end
    end

    context 'when the API call returns an unprocessable entity error' do
      before do
        allow(client).to receive(:post).and_raise(stub_faraday_422(['Oops!']))
      end

      it { is_expected.to be_failure }

      it 'rescues the error and returns a failure ServiceResult' do
        expect(subject.errors).to include('Oops!')
      end
    end

    context 'when no title was given' do
      let(:settings) { { } }

      it { is_expected.to be_failure }

      it 'contains a meaningful message' do
        expect(subject.errors).to include('Title cannot be blank')
      end
    end
  end
end
