class TimeCurveEntry < ActiveRecord::Base
  belongs_to :graph

  scope :ordered, order("converter_id ASC, value_type ASC, year ASC")
  scope :only_decades, where("year % 10 = 0")

  def preset_demand?
    true
  end

end

# == Schema Information
#
# Table name: time_curve_entries
#
#  id           :integer(4)      not null, primary key
#  graph_id     :integer(4)
#  converter_id :integer(4)
#  year         :integer(4)
#  value        :float
#  value_type   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

