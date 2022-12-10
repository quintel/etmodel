class CompareController < ApplicationController
  layout 'compare'

  before_action do
    authenticate_user!(show_as: :sign_in)
  end

  def index
    @scenarios = user_scenarios

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
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
end
