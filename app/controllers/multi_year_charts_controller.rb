# frozen_string_literal: true

class MultiYearChartsController < ApplicationController
  layout 'multi_year_charts'

  before_action :ensure_valid_config

  def index
    @scenarios = user_scenarios

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    base_id = params.require(:scenario_id)
    scenarios = Scenario::Interpolator.call(Api::Scenario.find(base_id))

    redirect_to myc_url([*scenarios.map { |s| s['id'] }, base_id])
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

  def myc_url(scenario_ids)
    [
      APP_CONFIG[:multi_year_charts_url],
      scenario_ids.join(','),
      'charts/final-demand'
    ].join('/')
  end

  def ensure_valid_config
    return if APP_CONFIG[:multi_year_charts_url]

    redirect_to root_path,
      notice: 'Missing multi_year_charts_url setting in config.yml'
  end
end
