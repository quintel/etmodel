# frozen_string_literal: true

require 'rails_helper'

describe FetchFromEsdlSuite, type: :service do
  include EsdlSuiteHelper

  let(:user) { FactoryBot.create(:user) }
  let(:file_path) { '/User/foo.esdl' }
  let(:access_token) { '123' }

  before { stub_esdl_suite_open_id_methods }

  def esdl_suite_id(fresh = true)
    expires = fresh ? 10.minutes.from_now : 10.minutes.ago
    EsdlSuiteId.create!(
      user: user,
      expires_at: expires,
      access_token: access_token,
      refresh_token: '456',
      id_token: '789'
    )
  end

  def stub_fetch_response(code, response_body)
    allow(HTTParty)
      .to receive(:get)
      .with(
        'https://drive.esdl.hesi.energy/store/resource/' + CGI.escape(file_path),
        { headers: { 'Authorization' => "Bearer #{access_token}" } }
      ).and_return(ServicesHelper::StubResponse.new(code, response_body))
  end

  context 'with unfresh esdl_suite_id' do
    subject { described_class.call(esdl_suite_id(false), file_path) }

    before { stub_access_token_refresh({}) }

    it { is_expected.to be_a(ServiceResult) }

    it 'returns a failed ServiceResult' do
      expect(subject).to be_failure
    end
  end

  context 'with fresh esdl_suite_id' do
    context 'with invalid file_path' do
      subject { described_class.call(esdl_suite_id, file_path) }

      before { stub_fetch_response(404, '') }

      it { is_expected.to be_a(ServiceResult) }

      it 'returns a failed ServiceResult' do
        expect(subject).to be_failure
      end
    end

    context 'with valid file_path' do
      subject { described_class.call(esdl_suite_id, file_path) }

      before { stub_fetch_response(200, 'FILE') }

      it { is_expected.to be_a(ServiceResult) }

      it 'returns a successful ServiceResult' do
        expect(subject).to be_successful
      end

      it 'returns a file' do
        expect(subject.value).to eq('FILE')
      end
    end
  end
end
