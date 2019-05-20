# frozen_string_literal: true

class MultiYearChartsController < ApplicationController
  layout 'multi_year_charts'

  before_action :ensure_valid_config
  before_action :require_user, only: :create

  def index
    @scenarios = user_scenarios

    respond_to do |format|
      format.html
      format.js
    end
  end

  # Creates a new MultiYearChart record based on the scenario specified in the
  # params.
  #
  # Redirects to the external MYC app when successful.
  #
  # POST /multi-year-charts
  def create
    base_id = params.require(:scenario_id)&.to_i

    result = CreateMultiYearChart.call(
      Api::Scenario.find(base_id),
      current_user
    )

    if result.successful?
      redirect_to helpers.myc_url(result.value)
    else
      flash.now[:error] = result.errors.join(', ')

      @scenarios = user_scenarios
      render :index, status: :unprocessable_entity
    end
  end

  private

  def user_scenarios
    return [] unless current_user

    scenarios = current_user.
      saved_scenarios.
      order('created_at DESC').
      page(params[:page]).
      per(50)

    SavedScenario.batch_load(scenarios)

    scenarios
  end

  def ensure_valid_config
    return if APP_CONFIG[:multi_year_charts_url]

    redirect_to root_path,
      notice: 'Missing multi_year_charts_url setting in config.yml'
  end
end
