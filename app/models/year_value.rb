# == Schema Information
#
# Table name: year_values
#
#  id                 :integer          not null, primary key
#  year               :integer
#  value              :float
#  description        :text
#  value_by_year_id   :integer
#  value_by_year_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class YearValue < ActiveRecord::Base
  has_paper_trail

  belongs_to :value_by_year, :polymorphic => true
  scope :select_year, lambda {|year| where(:year => year) }
end

