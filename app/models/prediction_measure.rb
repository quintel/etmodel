# == Schema Information
#
# Table name: prediction_measures
#
#  id            :integer(4)      not null, primary key
#  prediction_id :integer(4)
#  name          :string(255)
#  impact        :integer(4)
#  cost          :integer(4)
#  year_start    :integer(4)
#  actor         :string(255)
#  description   :text
#  created_at    :datetime
#  updated_at    :datetime
#  end_year      :integer(4)
#

class PredictionMeasure < ActiveRecord::Base
  belongs_to :prediction
  
  has_paper_trail
  
  validates :name, :presence => true
  
  IMPACT = {
    0 => '+-',
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
