# == Schema Information
#
# Table name: sidebar_items
#
#  id                   :integer          not null, primary key
#  key                  :string(255)
#  section              :string(255)
#  percentage_bar_query :text
#  nl_vimeo_id          :string(255)
#  en_vimeo_id          :string(255)
#  tab_id               :integer
#  position             :integer
#  parent_id            :integer
#

class SidebarItem < ActiveRecord::Base
  include AreaDependent

  has_one :area_dependency, as: :dependable, dependent: :destroy
  has_one :description, as: :describable, dependent: :destroy
  belongs_to :tab
  has_many :slides, dependent: :nullify
  belongs_to :parent, class_name: "SidebarItem"
  has_many :children, foreign_key: 'parent_id', class_name: "SidebarItem"

  accepts_nested_attributes_for :description, :area_dependency

  validates :key, presence: true, uniqueness: true
  validates :position, numericality: true

  scope :ordered, -> { order('position') }
  scope :gquery_contains, ->(search) { where("percentage_bar_query LIKE ?", "%#{search}%") }
  scope :roots, -> { where(parent_id: nil) }

  def parsed_key_for_admin
    "#{section} | #{key}"
  end

  def short_name
    "#{tab.try :key} : #{key}"
  end
end
