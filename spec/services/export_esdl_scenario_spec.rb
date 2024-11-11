# frozen_string_literal: true

require 'rails_helper'

describe ExportEsdlScenario, type: :service do
  subject { described_class.call(ete_scenario) }

  let(:ete_scenario) { 123_45 }
  let(:updated_file) { 'updated_file' }

  def stub_response(code, response_body)
    allow(HTTParty)
      .to receive(:post)
      .with(
        Settings.esdl_ete_url + 'export_esdl/',
        { body: { session_id: ete_scenario, environment: 'beta' } }
      ).and_return(ServicesHelper::StubResponse.new(code, response_body))
  end
  # with valid esdl
  context 'with valid scenario_id and esdl' do
    before { stub_response(200, { 'energy_system' => updated_file }) }

    it { is_expected.to be_a(ServiceResult) }

    it 'contains an updated esdl file' do
      expect(subject.value).to eq(updated_file)
    end
  end

  context 'with unsupported esdl' do
    before { stub_response(422, { 'message' => 'Solar pv not supported' }) }

    it { is_expected.to be_a(ServiceResult) }

    it { is_expected.to be_failure }
  end

  context 'when attached esdl could not be found' do
    before { stub_response(404, { 'message' => 'ESDL or scenario could not be found' }) }

    it { is_expected.to be_a(ServiceResult) }

    it { is_expected.to be_failure }
  end
end
