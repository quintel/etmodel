class PredictionValue < ActiveRecord::Base
  belongs_to :prediction
  
  has_paper_trail
  
  default_scope order('year')
  
  validates_presence_of :prediction_id, :year, :best , :message => "can't be blank"
  
end
