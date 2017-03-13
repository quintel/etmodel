# frozen_string_literal: true

# Fetches and presents scenario reports and summaries.
class ReportsController < ApplicationController
  include MainInterfaceController.new(:show)

  before_action :ensure_scenario

  # Shows a scenario report.
  #
  # GET /scenario/reports/:id
  def show
    @report = Report.find(params[:id].to_s.tr('-', '_'), I18n.locale)
  end

  private

  def ensure_scenario
    redirect_to('/') && return unless Current.setting.api_session_id
  end
end
