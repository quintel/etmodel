# frozen_string_literal: true

require 'rails_helper'

describe CreateNewsletterSubscription, type: :service do
  let(:service) { described_class.new('API_KEY', 'http://localhost/lists/1') }
  let(:result) { service.call(user) }

  let(:user) { FactoryBot.create(:user) }

  # --

  # Returns a Struct which quacks enough like an HTTParty::Response for our
  # purposes.
  def stub_response(code, uri: '', method: :get, body: {})
    allow(HTTParty)
      .to receive(method)
      .with(
        "http://localhost/lists/1/members/#{uri}",
        hash_including(basic_auth: { username: 'none', password: 'API_KEY' })
      )
      .and_return(ServicesHelper::StubResponse.new(code, body))
  end

  # Stubs a request to fetch contact data from Mailchimp.
  def stub_contact_response(retval)
    service = FetchMailchimpContact.new('', '')

    allow(FetchMailchimpContact)
      .to receive(:new).with('API_KEY', 'http://localhost/lists/1')
      .and_return(service)

    allow(service).to receive(:call).and_return(retval)
  end

  # --

  context 'when the contact does not yet exist' do
    before do
      stub_contact_response(ServiceResult.success(nil))
      stub_response(200, method: :post, body: { 'status' => 'pending' })
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the contact data' do
      expect(result.value).to eq('status' => 'pending')
    end
  end

  context 'when the contact exists' do
    let(:contact_data) { { 'id' => MailchimpService.remote_id(user.email) } }

    before { stub_contact_response(ServiceResult.success(contact_data)) }

    context 'when the contact status is "pending"' do
      let(:contact_data) { super().merge('status' => 'pending') }

      it 'is successful' do
        expect(result).to be_successful
      end

      it 'does not send a request to the remote API' do
        allow(service).to receive(:update_contact)
        result
        expect(service).not_to have_received(:update_contact)
      end
    end

    context 'when the contact is "unsubscribed"' do
      let(:contact_data) { super().merge('status' => 'unsubscribed') }

      before do
        stub_response(
          200,
          uri: MailchimpService.remote_id(user.email),
          method: :patch,
          body: { 'status' => 'pending' }
        )
      end

      it 'is successful' do
        expect(result).to be_successful
      end

      it 'sends a PATCH request to the remote API' do
        result

        expect(HTTParty).to have_received(:patch).with(
          %r{/members/#{MailchimpService.remote_id(user.email)}},
          hash_including(body: { status: 'pending' }.to_json)
        )
      end

      it 'returns the contact data' do
        expect(result.value).to eq('status' => 'pending')
      end
    end

    context 'when the contact is "subscribed"' do
      let(:contact_data) { super().merge('status' => 'subscribed') }

      it 'is successful' do
        expect(result).to be_successful
      end

      it 'does not send a request to the remote API' do
        allow(service).to receive(:update_contact)
        result
        expect(service).not_to have_received(:update_contact)
      end
    end

    context 'when updating the contact fails' do
      let(:contact_data) { super().merge('status' => 'unsubscribed') }

      before do
        stub_response(
          500,
          uri: MailchimpService.remote_id(user.email),
          method: :patch,
          body: {
            'status' => 500,
            'title' => 'InternalServerError',
            'detail' => 'An error occurred'
          }
        )
      end

      it 'is not successful' do
        expect(result).not_to be_successful
      end

      it 'includes the errors on the Result' do
        expect(result.errors).to eq([
          'Mailchimp error: 500 InternalServerError: An error occurred'
        ])
      end
    end
  end

  context 'when the service returns an error code fetching the contact' do
    before do
      stub_contact_response(ServiceResult.failure(
        'Mailchimp error: 500 InternalServerError: An error occurred'
      ))
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'includes the errors on the Result' do
      expect(result.errors).to eq([
        'Mailchimp error: 500 InternalServerError: An error occurred'
      ])
    end

    it 'does not send a create request to the remote API' do
      allow(service).to receive(:create_contact)
      result
      expect(service).not_to have_received(:create_contact)
    end

    it 'does not send an update request to the remote API' do
      allow(service).to receive(:update_contact)
      result
      expect(service).not_to have_received(:update_contact)
    end
  end
end
