# frozen_string_literal: true

# == Schema Information
#
# Table name: sidebar_items
#
#  key                  :string(255)
#  section              :string(255)
#  percentage_bar_query :text
#  tab_key              :integer
#  position             :integer
#  parent_key           :integer
#  description:         :hash

# This model represents the secondary menu-item category in the sidebar of the
# scenario section of the application. The ones you click to a `slide`.
# ie "Households", "Electricity" and "Fuel prices"
class SidebarItem < YModel::Base
  include AreaDependent::YModel
  include Describable

  index_on :key
  belongs_to :tab
  has_many :slides, foreign_key: :sidebar_item_key
  belongs_to :parent, class_name: 'SidebarItem'
  has_many :children, foreign_key: :parent_key, class_name: 'SidebarItem'

  class << self
    def ordered
      all.sort_by(&:position)
    end

    def gquery_contains(search)
      return all if search.blank? || search.empty?

      all.select { |si| si.percentage_bar_query.include?(search) }
    end

    def find_by_section_and_key(section, key)
      where(section: section, key: key)&.first
    end
  end

  def parsed_key_for_admin
    "#{section} | #{key}"
  end

  def short_name
    "#{tab.try :key} : #{key}"
  end

  def root?
    parent_key.nil?
  end

  def visible_children
    children.reject(&:area_dependent)
      .sort_by(&:position)
  end
end
