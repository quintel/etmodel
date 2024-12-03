# frozen_string_literal: true

# A scenario saved by a user for safe-keeping.
class SavedScenario < Dry::Struct
  # Extend and include ActiveModel to make form_for work
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion

  attribute :title,       Dry::Types['strict.string']
  attribute :area_code,   Dry::Types['strict.string']
  attribute :end_year,    Dry::Types['strict.integer']
  attribute :scenario_id, Dry::Types['strict.integer']

  attr_reader :errors

  def self.from_params(params)
    SavedScenario.new(**params.to_h.symbolize_keys)
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
end
