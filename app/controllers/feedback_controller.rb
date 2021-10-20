# frozen_string_literal: true

# Sends text-based feedback from users to app owners.
class FeedbackController < ApplicationController
  before_action :require_feedback_configured

  # Public: Sends the feedback form.
  #
  # POST /feedback
  def send_message
    if params[:name].present?
      # Invisible captcha.
      render json: {}
      return
    end

    feedback_params = params.permit(
      :locale,
      :page,
      :scenario_id,
      :saved_scenario_id,
      :text,
      charts: []
    ).to_h.symbolize_keys

    feedback_params[:user_agent] = request.env['HTTP_USER_AGENT']

    FeedbackMailer.feedback_message(
      current_user,
      merge_scenario_data(feedback_params)
    ).deliver

    render json: {}
  end

  private

  def merge_scenario_data(feedback_params)
    feedback_params[:scenario_id] ||= Current.setting.api_session_id

    if feedback_params[:scenario_id].present?
      scenario_res = CreateAPIScenario.call(
        protected: false,
        scenario_id: feedback_params[:scenario_id]
      )

      feedback_params[:scenario_url] =
        scenario_res.successful? ? scenario_url(id: scenario_res.value.id) : nil
    end

    feedback_params
  end

  def require_feedback_configured
    render_not_found unless Settings.feedback_email
  end
end
