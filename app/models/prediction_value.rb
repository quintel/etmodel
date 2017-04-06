# == Schema Information
#
# Table name: prediction_values
#
#  id            :integer          not null, primary key
#  prediction_id :integer
#  value         :float
#  year          :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class PredictionValue < ActiveRecord::Base
  belongs_to :prediction

  

  validates :value, presence: true
  validates :year, presence: true

  scope :future_first, -> { order("year DESC") }
end
