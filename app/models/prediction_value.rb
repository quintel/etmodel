# == Schema Information
#
# Table name: prediction_values
#
#  id            :integer(4)      not null, primary key
#  prediction_id :integer(4)
#  value         :float
#  year          :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class PredictionValue < ActiveRecord::Base
  belongs_to :prediction
  
  has_paper_trail
  
  default_scope order('year')
  
  scope :future_first, order("year DESC")
end
