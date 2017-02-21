# == Schema Information
#
# Table name: prediction_measures
#
#  id            :integer          not null, primary key
#  prediction_id :integer
#  name          :string(255)
#  impact        :integer
#  cost          :integer
#  year_start    :integer
#  actor         :string(255)
#  description   :text
#  created_at    :datetime
#  updated_at    :datetime
#  year_end      :integer
#

class PredictionMeasure < ActiveRecord::Base
  belongs_to :prediction
  
  
  
  validates :name, presence: true
  
  IMPACT = {
    1 => '+',
    2 => '++',
    3 => '+++'
  }
  
  COST = {
    0 => '-',
    1 => '$',
    2 => '$$',
    3 => '$$$'
  }
end
