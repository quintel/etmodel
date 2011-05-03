class YearValue < ActiveRecord::Base
  has_paper_trail

  belongs_to :value_by_year, :polymorphic => true
  scope :select_year, lambda {|year| where(:year => year) }
end

# == Schema Information
#
# Table name: year_values
#
#  id                 :integer(4)      not null, primary key
#  year               :integer(4)
#  value              :float
#  description        :text
#  value_by_year_id   :integer(4)
#  value_by_year_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

