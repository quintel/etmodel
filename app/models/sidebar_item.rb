# == Schema Information
#
# Table name: sidebar_items
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  key                     :string(255)
#  section                 :string(255)
#  percentage_bar_query    :text
#  order_by                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#  nl_vimeo_id             :string(255)
#  en_vimeo_id             :string(255)
#  additional_info_partial :string(255)
#

class SidebarItem < ActiveRecord::Base
  include AreaDependent
  has_one :area_dependency, :as => :dependable
  validates :key, :presence => true, :uniqueness => true
  
  def parsed_key_for_admin
    "#{section.andand} | #{key}"
  end
end
