# frozen_string_literal: true

# Fetches and presents scenario reports and summaries.
class ReportsController < ApplicationController
  layout 'report'

  # Shows a scenario report.
  #
  # GET /scenario/reports/:id
  def show
    @report = Report.find(params[:id].to_s.tr('-', '_'), I18n.locale)
  end

  # Automatically directs the visitor to an appropriate report for their
  # scenario.
  #
  # GET /scenario/reports/auto
  def auto
    redirect_to report_url(Report.key_for_area(Current.setting.area))
  end
end
