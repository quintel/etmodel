# frozen_string_literal: true

class MultiYearChartsController < ApplicationController
  layout 'multi_year_charts'

  before_action :ensure_valid_config
  before_action :require_user, except: :index

  def index
    @scenarios = user_scenarios
    @multi_year_charts = user_multi_year_charts

    respond_to do |format|
      format.html
      format.js do
        render(params[:wants] == 'scenarios' ? 'scenarios' : 'index')
      end
    end
  end

  # Creates a new MultiYearChart record based on the scenario specified in the
  # params.
  #
  # Redirects to the external MYC app when successful.
  #
  # POST /multi_year_charts
  def create
    result = CreateMultiYearChart.call(
      Api::Scenario.find(params.require(:scenario_id).to_i),
      current_user
    )

    if result.successful?
      redirect_to helpers.myc_url(result.value)
    else
      flash.now[:error] = result.errors.join(', ')

      @scenarios = user_scenarios
      @multi_year_charts = user_multi_year_charts

      render :index, status: :unprocessable_entity
    end
  end

  # Removes a MultiYearChart record.
  #
  # DELETE /multi_year_charts/:id
  def destroy
    DeleteMultiYearChart.call(
      current_user.multi_year_charts.find(params.require(:id))
    )

    redirect_to multi_year_charts_path
  end

  private

  def user_scenarios
    return [] unless current_user

    scenarios = current_user
      .saved_scenarios
      .order('created_at DESC')
      .page(params[:page])
      .per(50)

    SavedScenario.batch_load(scenarios)

    scenarios
  end

  def user_multi_year_charts
    return [] unless current_user

    current_user
      .multi_year_charts
      .where(area_code: Api::Area.keys)
      .order(created_at: :desc)
      .page(params[:page])
      .per(50)
  end

  def ensure_valid_config
    return if Settings.multi_year_charts_url

    redirect_to root_path,
      notice: 'Missing multi_year_charts_url setting in config.yml'
  end
end
