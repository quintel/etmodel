# frozen_string_literal: true

require 'rails_helper'

describe FetchMailchimpContact, type: :service do
  let(:service) { described_class.new('API_KEY', 'http://localhost/lists/1') }
  let(:result) { service.call(user) }

  let(:user) { FactoryBot.create(:user) }

  # Returns a Struct which quacks enough like an HTTParty::Response for our
  # purposes.
  def stub_response(code, uri, response_body = {})
    allow(HTTParty)
      .to receive(:get)
      .with(
        "http://localhost/lists/1/members/#{uri}",
        hash_including(basic_auth: { username: 'none', password: 'API_KEY' })
      )
      .and_return(ServicesHelper::StubResponse.new(code, response_body))
  end

  context 'when the contact exists' do
    before do
      stub_response(200, MailchimpService.remote_id(user.email), 'id' => 'abc')
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the user data' do
      expect(result.value).to eq('id' => 'abc')
    end
  end

  context 'when the contact does not exist' do
    before do
      stub_response(404, MailchimpService.remote_id(user.email), 'id' => 'abc')
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns nil inside the result' do
      expect(result.value).to be_nil
    end
  end

  context 'when the remote service returns an error' do
    before do
      stub_response(
        500,
        MailchimpService.remote_id(user.email),
        'status' => 500,
        'title' => 'InternalServerError',
        'detail' => 'An error occurred'
      )
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'contains the error message' do
      expect(result.errors).to eq([
        'Mailchimp error: 500 InternalServerError: An error occurred'
      ])
    end
  end
end
