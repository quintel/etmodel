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

require 'ymodel'


class Tab < YModel::Base
  include AreaDependent

  has_many :sidebar_items, dependent: :nullify
  has_one :area_dependency, as: :dependable, dependent: :destroy

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
