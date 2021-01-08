require 'rails_helper'

describe EsdlSuiteId do
  include EsdlSuiteHelper

  let(:user) { FactoryBot.create(:user) }
  let(:esdl_suite_id) do
    described_class.create!(
      user: user,
      expires_at: 10.minutes.from_now,
      access_token: '123',
      refresh_token: '456',
      id_token: '789'
    )
  end

  it { is_expected.to belong_to(:user) }

  context 'when access_token is expired' do
    before do
      stub_esdl_suite_open_id_methods
      esdl_suite_id.update(expires_at: 10.minutes.ago)
    end

    it 'is expired' do
      expect(esdl_suite_id).to be_expired
    end

    it '#fresh updates the token ' do
      expect { esdl_suite_id.fresh }.to(change { esdl_suite_id.expires_at })
    end
  end

  context 'when access_token is not expired' do
    it 'is not expired' do
      expect(esdl_suite_id).not_to be_expired
    end

    it '#fresh does not update the token ' do
      expect { esdl_suite_id.fresh }.not_to(change { esdl_suite_id })
    end
  end

  context 'when refresh_token is expired' do
    subject { esdl_suite_id.refresh }

    before do
      stub_esdl_suite_open_id_methods
      stub_access_token_refresh({})
      esdl_suite_id
    end

    it '#refresh removes the esdl_suite_id' do
      expect { subject }.to change { described_class.count }.by(-1)
    end

    it '#refresh does not persist the esdl_suite_id' do
      subject
      expect(esdl_suite_id).not_to be_persisted
    end
  end

  context 'when refresh_token is not expired' do
    subject { esdl_suite_id.refresh }

    before do
      stub_esdl_suite_open_id_methods
      stub_access_token_refresh({ access_token: '012' })
      esdl_suite_id
    end

    it '#refresh updates the esdl_suite_id' do
      expect { subject }.not_to(change { described_class.count })
    end

    it '#refresh updates the esdl_suite_ids access_token' do
      subject
      expect(esdl_suite_id.access_token).to eq('012')
    end

    it '#refresh persists the esdl_suite_id' do
      subject
      expect(esdl_suite_id).to be_persisted
    end
  end

  describe '.create_or_update' do
    subject { described_class.create_or_update(some_attributes) }

    let(:some_attributes) do
      {
        user: user,
        expires_at: 10.minutes.from_now,
        access_token: '012',
        refresh_token: '345',
        id_token: '678'
      }
    end

    context 'with existing id on user' do
      before { esdl_suite_id }

      it 'updates the esdl_suite_id' do
        subject
        expect(user.esdl_suite_id.access_token).to eq('012')
      end

      it 'does not change db count' do
        expect { subject }.not_to(change(described_class, :count))
      end
    end

    context 'with no existing id on user' do
      it 'creates the esdl_suite_id' do
        subject
        expect(user.esdl_suite_id.access_token).to eq('012')
      end

      it 'changes the db count' do
        expect { subject }.to(change(described_class, :count))
      end
    end
  end
end
