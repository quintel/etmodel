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

  validates :key, :presence => true, :uniqueness => true

  has_many :sidebar_items, :dependent => :nullify

  scope :ordered, -> { order('position') }

  def allowed_sidebar_items
    sidebar_items.roots.includes(:area_dependency).ordered.reject(&:area_dependent)
  end
end
