# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyController do
  context 'when updating a survey as a guest' do
    context 'with no survey' do
      let(:request) do
        put :answer_question, params: { question: 'background', answer: 'researcher' }
      end

      it 'creates a survey' do
        expect { request }.to change(Survey, :count).by(1)
      end

      it 'sets the answer' do
        request
        expect(Survey.last.background).to eq('Researcher')
      end

      it 'returns 200 OK' do
        expect(request).to be_ok
      end

      it 'assigns no user to the survey' do
        request
        expect(Survey.last.user).to be_nil
      end

      xit 'returns body ___'
    end

    context 'with a survey and one answered question' do
      let(:request) do
        put :answer_question, params: { question: 'how_often', answer: '4' }
      end

      before do
        put :answer_question, params: { question: 'background', answer: 'researcher' }
      end

      it 'does not create a survey' do
        expect { request }.not_to change(Survey, :count)
      end

      it 'sets the answer' do
        request
        expect(Survey.last.how_often).to eq(4)
      end

      it 'returns 200 OK' do
        expect(request).to be_ok
      end

      xit 'returns body ___'
    end
  end

  context 'when updating and signed in' do
    before { login_as(user) }

    let(:user) { FactoryBot.create(:user) }

    context 'with no survey' do
      let(:request) do
        put :answer_question, params: { question: 'background', answer: 'researcher' }
      end

      it 'creates a survey' do
        expect { request }.to change(Survey, :count).by(1)
      end

      it 'sets the answer' do
        request
        expect(Survey.last.background).to eq('Researcher')
      end

      it 'returns 200 OK' do
        expect(request).to be_ok
      end

      it 'assigns the user to the survey' do
        request
        expect(Survey.last.user).to eq(user)
      end

      xit 'returns body ___'
    end

    context 'with a survey and one answered question' do
      let(:request) do
        put :answer_question, params: { question: 'how_often', answer: '4' }
      end

      before do
        put :answer_question, params: { question: 'background', answer: 'researcher' }
      end

      it 'does not create a survey' do
        expect { request }.not_to change(Survey, :count)
      end

      it 'sets the answer' do
        request
        expect(Survey.last.how_often).to eq(4)
      end

      it 'returns 200 OK' do
        expect(request).to be_ok
      end

      xit 'returns body ___'
    end
  end
end
