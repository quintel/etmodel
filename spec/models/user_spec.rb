require 'rails_helper'

describe User do
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_one(:survey).dependent(:destroy) }

  describe '.from_jwt!' do
    let(:user) { described_class.from_jwt!(token) }

    context 'when given a valid token and the user does not exist' do
      let(:token) do
        { 'sub' => '123', 'user' => { 'name' => 'John Doe' } }
      end

      it 'creates a new user' do
        expect { user }.to change(described_class, :count).by(1)
      end

      it 'sets the user ID' do
        expect(user.id).to eq(123)
      end

      it 'sets the user name' do
        expect(user.name).to eq('John Doe')
      end
    end

    context 'when given a value token and the user already exists' do
      let!(:existing_user) { described_class.create!(id: 123, name: 'Jane Doe') }

      let(:token) do
        { 'sub' => '123', 'user' => { 'name' => 'John Doe' } }
      end

      it 'returns the existing user' do
        expect(user).to eq(existing_user)
      end

      it 'does not create a new user' do
        expect { user }.not_to change(described_class, :count)
      end
    end

    context 'when given a token without a "sub" claim' do
      let(:token) do
        { 'user' => { 'name' => 'John Doe' } }
      end

      it 'raises an error' do
        expect { user }.to raise_error(/Token does not contain user information/)
      end
    end

    context 'when given a token with a blank "sub" claim' do
      let(:token) do
        { 'sub' => '', 'user' => { 'name' => 'John Doe' } }
      end

      it 'raises an error' do
        expect { user }.to raise_error(/Token does not contain user information/)
      end
    end

    context 'when given a token without a "user" claim' do
      let(:token) do
        { 'sub' => '123' }
      end

      it 'raises an error' do
        expect { user }.to raise_error(/Token does not contain user information/)
      end
    end

    context 'when given a token without a "user.name" claim' do
      let(:token) do
        { 'sub' => '123', 'user' => {} }
      end

      it 'raises an error' do
        expect { user }.to raise_error(/Token does not contain user information/)
      end
    end

    context 'when the user already exists with stale identity data' do
      let!(:existing_user) { described_class.create!(id: 123, name: 'Jane Doe') }

      let(:token) do
        { 'sub' => '123', 'user' => { 'name' => 'John Doe', 'admin' => true } }
      end

      it "sets identity_user from the token's claims, even though the row already existed" do
        expect(user.identity_user).to be_admin
      end

      it 'admin? prefers the fresh claims over the persisted (stale) admin column' do
        expect(user).to be_admin
      end
    end
  end
end
