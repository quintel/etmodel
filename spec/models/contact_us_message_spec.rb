require 'rails_helper'

RSpec.describe ContactUsMessage do
  it { expect(described_class.new).to validate_presence_of(:email) }
  it { expect(described_class.new).to validate_presence_of(:message) }

  context 'when the e-mail domain is disallowed' do
    it 'has an error on the email' do
      message = described_class.new(email: 'example@energytransitionmodel.com')
      message.valid?

      expect(message.errors[:email]).to include('is not allowed')
    end
  end

  context 'when the message contains a disallowed word' do
    it 'has an error on the message' do
      message = described_class.new(message: 'want to sell your domain?')
      message.valid?

      expect(message.errors[:message]).to include('contains disallowed content')
    end
  end
end
