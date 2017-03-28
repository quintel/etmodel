# frozen_string_literal: true

# Fetches and presents scenario reports and summaries.
class ReportsController < ApplicationController
  include MainInterfaceController.new(:show)

  before_action :start_scenario_with_param, only: :show
  layout 'report'

  # Shows a scenario report.
  #
  # GET /scenario/reports/:id
  def show
    @report = Report.find(params[:id].to_s.tr('-', '_'), I18n.locale)

    respond_to do |wants|
      wants.html
      wants.pdf do
        pdf = WickedPdf.new.pdf_from_url(
          report_pdf_fetch_url,
          print_media_type: true,
          window_status: 'chartsDidLoad',
          margin: { top: 40, bottom: 40, left: 40, right: 40 }
        )

        render plain: pdf, layout: nil
      end
    end
  end

  private

  # Requests for PDF versions lack the scenario ID and other settings from the
  # user's session. Start a new scenario using the original as a base only for
  # the purpose of creating a PDF.
  def start_scenario_with_param
    return unless params[:scenario_id]

    new_scenario = Api::Scenario.create(
      scenario: { scenario: { scenario_id: params[:scenario_id] } }
    )

    Current.setting.api_session_id = new_scenario.id
  end

  # URL from which to request an HTML version of the report which will be
  # rendered as PDF.
  #
  # The host may be customised in config/config.yml in development environments
  # where you need to run multiple server instances.
  def report_pdf_fetch_url
    opts = { scenario_id: Current.setting.api_session_id }

    if APP_CONFIG[:report_pdf_host]
      uri = URI(APP_CONFIG[:report_pdf_host])
      opts[:protocol] = uri.scheme
      opts[:port]     = uri.port
      opts[:host]     = uri.host
    end

    report_url(params[:id], opts)
  end
end
