# frozen_string_literal: true

# Allows featuring and unfeaturing saved scenarios.
class FeaturedScenariosController < ApplicationController
  before_action :ensure_admin

  def new
    @featured_scenario = FeaturedScenario.new(saved_scenario: saved_scenario)
  end

  def create
    unless featured_scenario
      FeaturedScenario.create(featured_scenario_params.merge(saved_scenario: saved_scenario))
    end

    redirect_to saved_scenario_url(saved_scenario)
  end

  def destroy
    featured_scenario.destroy
    redirect_to saved_scenario_url(saved_scenario)
  end

  private

  def featured_scenario_params
    params.require(:featured_scenario).permit(:group)
  end

  def saved_scenario
    SavedScenario.find(params[:id])
  end

  def featured_scenario
    saved_scenario.featured_scenario
  end

  def ensure_admin
    render_not_found unless current_user&.admin?
  end
end
