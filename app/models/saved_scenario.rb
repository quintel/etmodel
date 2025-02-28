# frozen_string_literal: true

class SavedScenario < Dry::Struct
  class ScenarioUser < Dry::Struct
    attribute :id,   Dry::Types['strict.integer']
    attribute :role, Dry::Types['strict.integer']

    def is_viewer?
      role >= 1
    end

    def is_collaborator?
      role >= 2
    end

    def is_owner?
      role >= 3
    end
  end

  # Extend and include ActiveModel to make form_for work
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion

  attribute :title,                Dry::Types['strict.string']
  attribute :area_code,            Dry::Types['strict.string']
  attribute :end_year,             Dry::Types['strict.integer']
  attribute :scenario_id,          Dry::Types['strict.integer']
  attribute :private,              Dry::Types['strict.bool'].optional.default(false)
  attribute :saved_scenario_users, Dry::Types['strict.array'].of(ScenarioUser).optional.default([].freeze)

  attr_reader :errors

  def collaborator?(current_user)
    saved_scenario_users.any? do |user|
      user.id == current_user.id && user.is_collaborator?
    end
  end

  def viewer?(current_user)
    saved_scenario_users.any? do |user|
      user.id == current_user.id && user.is_viewer?
    end
  end

  def self.from_params(params)
    params = params.to_h.symbolize_keys
    allowed_params = params.slice(:title, :area_code, :end_year, :scenario_id, :private, :version)

    if params[:saved_scenario_users].is_a?(Array)
      allowed_params[:saved_scenario_users] = params[:saved_scenario_users].map do |user_params|
        user_params = user_params.to_h.symbolize_keys
        user_id = user_params[:user_id].present? ? user_params[:user_id].to_i : 0
        role    = user_params[:role].present? ? role_to_int(user_params[:role]) : 0
        ScenarioUser.new(id: user_id, role: role)
      end
    end

    SavedScenario.new(**allowed_params)
  end

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  def persisted?
    false
  end

  def valid?
    @errors.empty?
  end

  private

  def self.role_to_int(role)
    case role.to_s.downcase.strip
    when "viewer" then 1
    when "collaborator" then 2
    when "scenario_owner" then 3
    else 0
    end
  end
end
