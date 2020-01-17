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

require 'ymodel'

# This model represents the secondary menu-item category in the sidebar of the
# scenario section of the application. The ones you click to a `slide`.
# ie "Households", "Electricity" and "Fuel prices"
class SidebarItem < YModel::Base
  include AreaDependent

  has_one :area_dependency, as: :dependable
  has_one :description, as: :describable
  has_many :slides
  belongs_to :parent, class_name: 'SidebarItem'
  has_many :children, foreign_key: :parent_id, class_name: 'SidebarItem'

  class << self
    def ordered
      all.sort_by(&:position)
    end

    def gquery_contains(search)
      all.select { |rec| rec.percentage_bar_query.include?(search || '') }
    end

    def find_by_section_and_key(section, key)
      where(section: section, key: key)&.first
    end
  end

  def tab
    Tab.find(tab_id)
  end

  def parsed_key_for_admin
    "#{section} | #{key}"
  end

  def short_name
    "#{tab.try :key} : #{key}"
  end

  def root?
    parent_id.nil?
  end

  def visible_children
    children.reject(&:area_dependent)
            .sort_by(&:position)
  end
end
