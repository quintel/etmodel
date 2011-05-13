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
end

# == Schema Information
#
# Table name: tabs
#
#  id          :integer(4)      not null, primary key
#  key         :string(255)
#  nl_vimeo_id :string(255)
#  en_vimeo_id :string(255)
#
