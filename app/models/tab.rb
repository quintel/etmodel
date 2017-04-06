# == Schema Information
#
# Table name: tabs
#
#  id          :integer          not null, primary key
#  key         :string(255)
#  nl_vimeo_id :string(255)
#  en_vimeo_id :string(255)
#  position    :integer
#

class Tab < ActiveRecord::Base
  include AreaDependent

  validates :key, presence: true, uniqueness: true

  has_many :sidebar_items, dependent: :nullify
  has_one :area_dependency, as: :dependable, dependent: :destroy

  accepts_nested_attributes_for :area_dependency

  scope :ordered, -> { order('position') }

  # Returns all Tabs intended for display to ordinary users.
  def self.frontend
    ordered.reject(&:area_dependent)
  end

  def allowed_sidebar_items
    sidebar_items.roots.includes(:area_dependency).ordered.reject(&:area_dependent)
  end
end
