# frozen_string_literal: true

require 'delegate'

# Survey contains the results of question asked to ETM visitors. The answers for each question are
# stored as part of the survey (rather than an "Answers" model/table) as it's unlikely we'll add
# more questions in the future, and Survey will be removed within a few months.
class Survey < ApplicationRecord
  Question = Struct.new(:key, :type) do
    def coerce_value(user_value)
      user_value
    end

    def as_json(*)
      { key: key, type: type }
    end

    def final_page?
      false
    end
  end

  # A question where the user may enter any text value they wish.
  class TextQuestion < Question
    attr_reader :max_length

    def initialize(key, type: :text, max_length: 8192)
      super(key, type)
      @max_length = max_length
    end

    def coerce_value(user_value)
      super(user_value.nil? ? nil : user_value.to_s.strip[0...@max_length])
    end

    def as_json(*)
      super.merge(max_length: max_length)
    end
  end

  # Represents a question where the user may select one of a number of choices, or enter their own
  # custom text value.
  class MultipleChoiceQuestion < TextQuestion
    attr_reader :choices

    def initialize(key, choices, max_length: 256)
      super(key, type: :multiple_choice, max_length: max_length)
      @choices = choices
      @max_length = max_length
    end

    # def coerce_value(user_value)
    #   return super(user_value) unless @choices.include?(user_value)

    #   # Translate user_value to English if applicable, else use literal.
    #   super(I18n.t(
    #     "survey.questions.background.choices.#{user_value}",
    #     default: user_value,
    #     locale: :en
    #   ))
    # end

    def as_json(*)
      super.merge(choices: choices)
    end
  end

  # A question where the user is asked to provide a value between 1 and 5.
  class RangeQuestion < Question
    def initialize(key)
      super(key, :range)
    end

    def choices
      [1, 2, 3, 4, 5]
    end

    def coerce_value(user_value)
      user_value.to_i.clamp(choices.first, choices.last) if user_value.present?
    end

    def as_json(*)
      super.merge(choices: choices)
    end
  end

  # Wraps the question on the final page. Is not counted as a question.
  class FinalPage < SimpleDelegator
    def final_page?
      true
    end
  end

  QUESTIONS = [
    RangeQuestion.new(:how_often),
    MultipleChoiceQuestion.new(
      :background, %w[energy_company consultant researcher student government not_saying other]
    ),
    TextQuestion.new(:typical_tasks),
    RangeQuestion.new(:how_easy),
    RangeQuestion.new(:how_useful),
    FinalPage.new(TextQuestion.new(:feedback))
  ].freeze

  CSV_COLUMNS = [:id, :user_id, *QUESTIONS.map(&:key)].map(&:to_s).freeze

  belongs_to :user, optional: true

  validates :background, length: { maximum: 256 }, allow_nil: true
  validates :feedback, :typical_tasks, length: { maximum: 8192 }, allow_nil: true
  validates :how_often, :how_easy, :how_useful, inclusion: { in: [1, 2, 3, 4, 5] }, allow_nil: true

  # Public: Retrieves the survey for the current user and session.
  #
  # Returns a survey.
  def self.from_session(current_user, session)
    if current_user&.survey
      current_user.survey
    elsif session[:survey_id] && Survey.exists?(session[:survey_id])
      Survey.find(session[:survey_id])
    else
      Survey.new(user: current_user)
    end
  end

  # Public: Answers the question matching the `key` with the given `answer`.
  #
  # Returns true when the update succeeds, false otherwise. Returns false if no such question
  # exists.
  def answer_question(key, answer)
    key = key.to_s

    if (question = QUESTIONS.detect { |q| q.key.to_s == key })
      update({ question.key => question.coerce_value(answer) })
    else
      false
    end
  end

  # Public: Returns the first unanswered question.
  def next_question
    QUESTIONS.detect { |question| self[question.key].nil? && !question.final_page? }
  end

  # Public: Returns if the survey has been completed with all questions answered.
  def finished?
    next_question.nil?
  end

  # Public: Returns the value given by the user as an answer to the question.
  def answer_for(question)
    self[question.key]
  end

  # Public: Returns the value given by the user as an answer to the question, translated to English
  # when appropriate.
  def localized_answer_for(question)
    raw_value = answer_for(question)

    return raw_value unless question.is_a?(MultipleChoiceQuestion)
    return raw_value if raw_value.blank?

    I18n.t(
      "survey.questions.#{question.key}.choices.#{raw_value}",
      default: raw_value,
      locale: :en
    )
  end

  def as_json(*)
    {
      finished: finished?,
      questions: QUESTIONS.map do |question|
        question.as_json.merge(
          answered: !answer_for(question).nil?,
          value: answer_for(question)
        )
      end
    }
  end
end
