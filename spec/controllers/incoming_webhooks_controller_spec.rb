# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomingWebhooksController, '#mailchimp' do
  context 'when type=subscribe' do
    let(:request) do
      post :mailchimp, params: {
        key: 'abc',
        type: 'subscribe',
        data: { 'email' => 'user@example.org' }
      }
    end

    context 'when the user exists in the database' do
      let!(:user) do
        FactoryBot.create(:user, email: 'user@example.org', allow_news: false)
      end

      it 'is successful' do
        expect(request).to be_successful
      end

      it 'updates the user allow_news to be true' do
        expect { request }
          .to change { user.reload.allow_news }
          .from(false)
          .to(true)
      end
    end

    context 'when the user does not exist in the database' do
      it 'is successful' do
        expect(request).to be_successful
      end
    end
  end

  context 'when type=unsubscribe' do
    let(:request) do
      post :mailchimp, params: {
        key: 'abc',
        type: 'unsubscribe',
        data: { 'email' => 'user@example.org' }
      }
    end

    context 'when the user exists in the database' do
      let!(:user) do
        FactoryBot.create(:user, email: 'user@example.org', allow_news: true)
      end

      it 'is successful' do
        expect(request).to be_successful
      end

      it 'updates the user allow_news to be false' do
        expect { request }
          .to change { user.reload.allow_news }
          .from(true)
          .to(false)
      end
    end

    context 'when the user does not exist in the database' do
      it 'is successful' do
        expect(request).to be_successful
      end
    end
  end

  context 'when type=upemail' do
    let(:request) do
      post :mailchimp, params: {
        key: 'abc',
        type: 'unsubscribe',
        data: { 'old_email' => 'user@example.org' }
      }
    end

    let!(:user) do
      FactoryBot.create(:user, email: 'user@example.org', allow_news: true)
    end

    it 'is successful' do
      expect(request).to be_successful
    end

    it 'updates the user allow_news to be false' do
      expect { request }
        .to change { user.reload.allow_news }
        .from(true)
        .to(false)
    end
  end

  context 'when the "type" param is missing' do
    let(:request) do
      post :mailchimp, params: {
        key: 'abc',
        data: { 'email' => 'user@example.org' }
      }
    end

    it 'returns Bad Request' do
      expect(request).to be_bad_request
    end
  end

  context 'when "data" params are missing' do
    let(:request) do
      post :mailchimp, params: {
        key: 'abc',
        type: 'subscribe'
      }
    end

    it 'returns Bad Request' do
      expect(request).to be_bad_request
    end
  end

  context 'with an invalid webhook key' do
    it 'returns forbidden' do
      post :mailchimp, params: { key: 'cba' }
      expect(response).to be_forbidden
    end
  end
end
