require 'rails_helper'

describe User do
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:saved_scenarios).dependent(:destroy) }
  it { is_expected.to have_many(:multi_year_charts).dependent(:destroy) }
  it { is_expected.to have_one(:esdl_suite_id).dependent(:destroy) }
  it { is_expected.to have_one(:survey).dependent(:destroy) }

  describe '.from_identity!' do
    context 'when given an identity which is not yet stored' do
      let(:identity_user) do
        Identity::User.new(id: 123, email: 'hello@example.org', name: 'John Doe', roles: [])
      end

      it 'adds a user to the database' do
        expect { described_class.from_identity!(identity_user) }
          .to change(described_class, :count).by(1)
      end

      it 'adds a user with the correct ID' do
        expect { described_class.from_identity!(identity_user) }
          .to change { described_class.where(id: 123).count }.by(1)
      end

      it "sets the user's name" do
        expect(described_class.from_identity!(identity_user).name).to eq('John Doe')
      end
    end

    context 'when given an identity which is not valid' do
      let(:identity_user) do
        Identity::User.new(id: 123, email: 'hello@example.org', name: '', roles: [])
      end

      it 'raises an ActiveRecord::RecordInvalid' do
        expect { described_class.from_identity!(identity_user) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when given an identity which has been stored' do
      let!(:user) { FactoryBot.create(:user, id: 123, name: 'Jane Doe') }

      let(:identity_user) do
        Identity::User.new(id: 123, email: 'hello@example.org', name: 'New name', roles: [])
      end

      it 'does not add a user to the database' do
        expect { described_class.from_identity!(identity_user) }
          .not_to change(described_class, :count)
      end

      it 'has a user with the correct ID' do
        expect { described_class.from_identity!(identity_user) }
          .not_to change { described_class.where(id: 123).count }.from(1)
      end

      it "sets the user's new name" do
        expect { described_class.from_identity!(identity_user) }
          .to change { user.reload.name }.from('Jane Doe').to('New name')
      end
    end
  end
end
