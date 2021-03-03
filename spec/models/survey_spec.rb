# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey, type: :model do
  it { is_expected.to validate_inclusion_of(:how_easy).in_array([1, 2, 3, 4, 5]) }
  it { is_expected.to validate_inclusion_of(:how_often).in_array([1, 2, 3, 4, 5]) }
  it { is_expected.to validate_inclusion_of(:how_useful).in_array([1, 2, 3, 4, 5]) }
  it { is_expected.to validate_length_of(:background).is_at_most(256) }
  it { is_expected.to validate_length_of(:feedback).is_at_most(8192) }
  it { is_expected.to validate_length_of(:typical_tasks).is_at_most(8192) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_db_index([:user_id]) }

  describe '#answer_question' do
    let(:survey) { described_class.create! }

    context 'when providing an invalid question key' do
      it 'returns false' do
        expect(survey.answer_question('invalid', 'yes')).to be(false)
      end
    end

    context 'when providing an answer' do
      it 'updates the record' do
        expect { survey.answer_question('background', 'consultant') }
          .to change { survey.reload.background }.from(nil).to('Consultant')
      end

      it 'returns true' do
        expect(survey.answer_question('background', 'consultant')).to be(true)
      end
    end
  end

  describe '#next_question' do
    let(:survey) { described_class.new }

    context 'when no questions have been answered' do
      it 'returns the first question' do
        expect(survey.next_question).to eq(Survey::QUESTIONS[0])
      end

      it 'is not finished' do
        expect(survey).not_to be_finished
      end
    end

    context 'when the first question has been answered' do
      before { survey[Survey::QUESTIONS[0].key] = 'answer' }

      it 'returns the second question' do
        expect(survey.next_question).to eq(Survey::QUESTIONS[1])
      end

      it 'is not finished' do
        expect(survey).not_to be_finished
      end
    end

    context 'when the first and second questions have been answered' do
      before do
        survey[Survey::QUESTIONS[0].key] = 'answer'
        survey[Survey::QUESTIONS[1].key] = 'answer'
      end

      it 'returns the third question' do
        expect(survey.next_question).to eq(Survey::QUESTIONS[2])
      end

      it 'is not finished' do
        expect(survey).not_to be_finished
      end
    end

    context 'when the second question has been answered' do
      before { survey[Survey::QUESTIONS[1].key] = 'answer' }

      it 'returns the first question' do
        expect(survey.next_question).to eq(Survey::QUESTIONS[0])
      end

      it 'is not finished' do
        expect(survey).not_to be_finished
      end
    end

    context 'when all questions have been answered' do
      before do
        Survey::QUESTIONS.each do |question|
          survey[question.key] = 'answer'
        end
      end

      it 'returns nil' do
        expect(survey.next_question).to be_nil
      end

      it 'is finished' do
        expect(survey).to be_finished
      end
    end
  end
end
