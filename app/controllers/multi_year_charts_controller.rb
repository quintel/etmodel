# frozen_string_literal: true

class MultiYearChartsController < ApplicationController
  layout 'multi_year_charts'

  load_resource only: %i[show discard undiscard]

  before_action :ensure_valid_config

  before_action except: %i[show discard undiscard] do
    authenticate_user!(show_as: :sign_in)
  end

  before_action only: %i[discard undiscard] do
    authorize!(:destroy, @multi_year_chart)
  end

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

  # Part of the My Scenarios view, lists all MYC that are not discarded
  #
  # GET multi_year_charts/list
  def list
    @multi_year_charts = user_multi_year_charts
      .kept
      .includes(:user)
      .order('created_at DESC')
      .page(params[:page])
      .per(50)

    respond_to do |format|
      format.html {render :layout => 'application'}
    end
  end

  def show
    respond_to do |format|
      format.html { render layout: 'application' }
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
      engine_client,
      current_user.saved_scenarios.find(params.require(:scenario_id)),
      current_user
    )

    if result.successful?
      redirect_to helpers.myc_url(result.value), allow_other_host: true
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
      engine_client,
      current_user.multi_year_charts.find(params.require(:id))
    )

    redirect_to multi_year_charts_path
  end

  # Soft-deletes the myc so that it no longer appears in listings.
  #
  # PUT /multi_year_charts/:id/discard
  def discard
    unless @multi_year_chart.discarded?
      @multi_year_chart.discarded_at = Time.zone.now
      @multi_year_chart.save(touch: false)

      flash.notice = t('scenario.trash.discarded_flash')
      flash[:undo_params] = [undiscard_multi_year_chart_path(@multi_year_chart), { method: :put }]
    end

    redirect_back(fallback_location: list_multi_year_charts_path)
  end

  # Removes the soft-deletes of the scenario.
  #
  # PUT /multi_year_charts/:id/undiscard
  def undiscard
    unless @multi_year_chart.kept?
      @multi_year_chart.discarded_at = nil
      @multi_year_chart.save(touch: false)

      flash.notice = t('scenario.trash.undiscarded_flash')
      flash[:undo_params] = [discard_multi_year_chart_path(@multi_year_chart), { method: :put }]
    end

    redirect_back(fallback_location: discarded_saved_scenarios_path)
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
      .where(area_code: Engine::Area.keys)
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
