# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackController do
  around do |example|
    original = Settings.feedback_email
    Settings.feedback_email = feedback_email

    begin
      example.call
    ensure
      Settings.feedback_email = original
    end
  end

  context 'when no feedback_email is configured' do
    let(:feedback_email) { nil }

    it 'responds with 404' do
      post :send_message
      expect(response).to be_not_found
    end
  end

  context 'when sending feedback as a guest' do
    let(:feedback_email) { 'devnull@example.org' }
    let(:request) { post :send_message, params: { page: '/' } }

    it 'responds successfully' do
      expect(request).to be_successful
    end

    it 'sends a message' do
      allow(FeedbackMailer).to receive(:feedback_message).and_call_original
      request

      expect(FeedbackMailer).to have_received(:feedback_message).with(
        nil,
        page: '/',
        scenario_id: nil,
        user_agent: 'Rails Testing'
      )
    end
  end

  context 'when sending feedback as a user' do
    let(:feedback_email) { 'devnull@example.org' }
    let(:user) { FactoryBot.create(:user) }
    let(:request) { post(:send_message, params: { page: '/' }) }

    before { login_as(user) }

    it 'responds successfully' do
      expect(request).to be_successful
    end

    it 'sends a message including user information' do
      allow(FeedbackMailer).to receive(:feedback_message).and_call_original
      request

      expect(FeedbackMailer).to have_received(:feedback_message).with(
        user,
        page: '/',
        scenario_id: nil,
        user_agent: 'Rails Testing'
      )
    end
  end

  context 'when sending feedback with an active scenario' do
    let(:feedback_email) { 'devnull@example.org' }
    let(:request) { post(:send_message, params: { page: '/', scenario_id: 1 }) }

    before do
      allow(CreateAPIScenario).to receive(:call)
        .with(protected: false, scenario_id: '1')
        .and_return(ServiceResult.success(Api::Scenario.new(id: 2)))
    end

    it 'responds successfully' do
      expect(request).to be_successful
    end

    it 'sends a message including user information' do
      allow(FeedbackMailer).to receive(:feedback_message).and_call_original
      request

      expect(FeedbackMailer).to have_received(:feedback_message).with(
        nil,
        page: '/',
        scenario_id: '1',
        scenario_url: 'http://test.host/scenarios/2',
        user_agent: 'Rails Testing'
      )
    end
  end
end
