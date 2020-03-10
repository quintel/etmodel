# frozen_string_literal: true

# == Schema Information
#
# Table name: tabs
#
#  id          :integer
#  key         :string
#  nl_vimeo_id :string
#  en_vimeo_id :string
#  position    :integer
#

# This model represents the top-most clickable menu-item category in the
# sidebar of the scenario section of the application. i.e. Demand, Supply,
# Flexibility.
class Tab < YModel::Base
  include AreaDependent::YModel

  index_on :key
  has_many :sidebar_items, foreign_key: :tab_key

  # Returns all Tabs intended for display to ordinary users.
  def self.frontend
    ordered.reject(&:area_dependent)
  end

  def self.ordered
    all.sort_by(&:position)
  end

  def allowed_sidebar_items
    sidebar_items.select(&:root?)
      .reject(&:area_dependent)
      .sort_by(&:position)
  end
end
