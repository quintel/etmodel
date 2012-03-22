# == Schema Information
#
# Table name: tabs
#
#  id          :integer(4)      not null, primary key
#  key         :string(255)
#  nl_vimeo_id :string(255)
#  en_vimeo_id :string(255)
#

class Tab < ActiveRecord::Base
  has_paper_trail

  validates :key, :presence => true, :uniqueness => true

  has_many :sidebar_items, :dependent => :nullify

  scope :ordered, order('position')

  attr_accessible :key, :nl_vimeo_id, :en_vimeo_id, :position
end
