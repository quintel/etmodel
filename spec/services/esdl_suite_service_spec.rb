# frozen_string_literal: true

require 'rails_helper'

describe EsdlSuiteService, type: :service do
  include EsdlSuiteHelper

  let(:user) { FactoryBot.create(:user) }
  let(:service) { described_class.new(provider_url, client_id, 'secret', redirect_url) }

  describe '#authenticate' do
    subject { service.authenticate('code', 'nonce', user) }

    context 'with valid code and valid nonce' do
      before do
        stub_esdl_suite_open_id_methods
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.to be_successful }

      it 'creates a new EsdlSuiteId in the database' do
        expect { subject }.to change { EsdlSuiteId.count }.by(1)
      end
    end

    context 'with valid code and invalid nonce' do
      before do
        stub_esdl_suite_open_id_methods(valid_nonce: false)
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.not_to be_successful }

      it 'does not create a new EsdlSuiteId in the database' do
        expect { subject }.not_to(change { EsdlSuiteId.count })
      end
    end

    context 'with invalid code and valid nonce' do
      before do
        stub_esdl_suite_open_id_methods(valid_code: false)
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.not_to be_successful }

      it 'does not create a new EsdlSuiteId in the database' do
        expect { subject }.not_to(change { EsdlSuiteId.count })
      end
    end

    context 'with invalid code and invalid nonce' do
      before do
        stub_esdl_suite_open_id_methods(valid_nonce: false, valid_code: false)
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.not_to be_successful }

      it 'does not create a new EsdlSuiteId in the database' do
        expect { subject }.not_to(change { EsdlSuiteId.count })
      end
    end
  end
end
