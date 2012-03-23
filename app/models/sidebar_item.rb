# == Schema Information
#
# Table name: sidebar_items
#
#  id                   :integer(4)      not null, primary key
#  key                  :string(255)
#  section              :string(255)
#  percentage_bar_query :text
#  nl_vimeo_id          :string(255)
#  en_vimeo_id          :string(255)
#  tab_id               :integer(4)
#  position             :integer(4)
#

class SidebarItem < ActiveRecord::Base
  include AreaDependent

  has_paper_trail

  has_one :area_dependency, :as => :dependable, :dependent => :destroy
  has_one :description, :as => :describable, :dependent => :destroy
  accepts_nested_attributes_for :description, :area_dependency

  validates :key, :presence => true, :uniqueness => true

  scope :gquery_contains, lambda{|search| where("percentage_bar_query LIKE ?", "%#{search}%")}

  belongs_to :tab
  has_many :slides, :dependent => :nullify

  scope :ordered, order('position')

  def parsed_key_for_admin
    "#{section.andand} | #{key}"
  end

  def short_name
    "#{tab.try :key} : #{key}"
  end
end
