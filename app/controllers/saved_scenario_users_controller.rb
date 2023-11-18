# frozen_string_literal: true

# The controller that handles calls to collections of SavedScenarioUsers
# for a given SavedScenario.
class SavedScenarioUsersController < ApplicationController
  before_action :load_and_authorize_saved_scenario
  before_action :load_saved_scenario_user, only: %i[update confirm_destroy destroy]

  after_action :clear_flash, only: %i[create update destroy]

  # Render a page with a table showing all SavedScenarioUsers for a SavedScenario.
  #
  # GET /saved_scenarios/:saved_scenario_id/users
  def index
    respond_to do |format|
      format.html
    end
  end

  # Renders a form for adding a user to a given SavedScenario with a specific role.
  #
  # GET /saved_scenarios/:saved_scenario_id/users/new
  def new
    @saved_scenario_user = SavedScenarioUser.new(saved_scenario_id: @saved_scenario.id)

    render 'new', layout: false
  end

  # Creates a new SavedScenarioUser for the given SavedScenario.
  # Renders the updated user-table on success or a flash message on failure.
  #
  # POST /saved_scenarios/:saved_scenario_id/users
  def create
    saved_scenario_user = SavedScenarioUser.create(
      saved_scenario_id: @saved_scenario.id,
      user_email: permitted_params[:saved_scenario_user][:user_email],
      role_id: permitted_params[:saved_scenario_user][:role_id]&.to_i
    )

    if saved_scenario_user.save
      saved_scenario_user.create_api_scenario_user(engine_client)

      @saved_scenario.reload

      respond_to do |format|
        format.js { render 'user_table', layout: false }
      end
    else
      flash[:alert] = \
        if saved_scenario_user.errors.first.attribute == :user_email
          t('scenario.users.errors.create_email')
        else
          "#{t('scenario.users.errors.create')} #{t('scenario.users.errors.general')}"
        end

      respond_to do |format|
        format.js { render 'form_flash', layout: false }
      end
    end
  end

  # Updates an existing SavedScenarioUser for this SavedScenario.
  # Renders the updated user-table on success or a flash message on failure.
  #
  # Currently it is only possible to update a user's role (role_id).
  #
  # PUT /saved_scenarios/:saved_scenario_id/users/:id
  def update
    @saved_scenario_user.role_id = permitted_params[:saved_scenario_user][:role_id]&.to_i

    if @saved_scenario_user.save
      @saved_scenario_user.update_api_scenario_user(engine_client)

      @saved_scenario.reload

      respond_to do |format|
        format.js { render 'user_table', layout: false }
      end
    else
      flash[:alert] = "#{t('scenario.users.errors.update')} #{t('scenario.users.errors.general')}"

      respond_to do |format|
        format.js { render 'flash', layout: false }
      end
    end
  end

  # Shows a form asking for confirmation on destroying a SavedScenarioUser.
  #
  # GET /saved_scenarios/:saved_scenario_id/users/:id/confirm_destroy
  def confirm_destroy
    render 'confirm_destroy', layout: false
  end

  # Destroys an existing SavedScenarioUser for this SavedScenario.
  # Renders the updated user-table on success or a flash message on failure.
  #
  # PUT /saved_scenarios/:saved_scenario_id/users/:id
  def destroy
    if @saved_scenario_user.destroy
      @saved_scenario_user.destroy_api_scenario_user(engine_client)

      respond_to do |format|
        format.js { render 'user_table', layout: false }
      end
    else
      flash[:alert] = "#{t('scenario.users.errors.destroy')} #{t('scenario.users.errors.general')}"

      respond_to do |format|
        format.js { render 'flash', layout: false }
      end
    end
  end

  private

  def permitted_params
    params.permit(:saved_scenario_id, :id, :role_id, saved_scenario_user: %i[user_id user_email role_id])
  end

  def load_and_authorize_saved_scenario
    raise CanCan::AccessDenied if current_user.blank?

    @saved_scenario = \
      if current_user.admin?
        SavedScenario.find(permitted_params[:saved_scenario_id])
      else
        current_user.saved_scenarios.find(permitted_params[:saved_scenario_id])
      end

    raise ActiveRecord::RecordNotFound if @saved_scenario.blank?
    raise CanCan::AccessDenied unless current_user.admin? || @saved_scenario.owner?(current_user)
  end

  def load_saved_scenario_user
    raise ActiveRecord::RecordNotFound if permitted_params[:id].blank? && permitted_params[:saved_scenario_user][:user_id].blank?

    @saved_scenario_user = \
      if permitted_params[:id].present?
        @saved_scenario.saved_scenario_users.find(permitted_params[:id])
      else
        @saved_scenario.saved_scenario_users.find_by(user_id: permitted_params[:saved_scenario_user][:user_id])
      end

    raise ActiveRecord::RecordNotFound if @saved_scenario_user.blank?
  end

  def clear_flash
    flash.clear
  end
end
