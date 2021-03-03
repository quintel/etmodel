# frozen_string_literal: true

# Renders survey questions.
class SurveyController < ApplicationController
  rescue_from ActionController::ParameterMissing do
    head(:bad_request)
  end

  def show
    render json: survey
  end

  # PUT /survey/:question
  def answer_question
    question = params.require(:question)
    answer   = params[:answer] || ''

    # If the user signed in part-way through the survey, assign the survey to them.
    survey.user = current_user if current_user && survey.user.blank?

    if survey.answer_question(question, answer)
      # Set the survey ID for guests, so they may continue adding date to the same record.
      session[:survey_id] = survey.id unless current_user

      head(:ok)
    else
      render json: { errors: survey.errors }, status: :unprocessable_entity
    end
  end

  private

  def survey
    @survey ||=
      if current_user&.survey
        current_user.survey
      elsif session[:survey_id] && Survey.exists?(session[:survey_id])
        Survey.find(session[:survey_id])
      else
        Survey.new(user: current_user)
      end
  end
end
