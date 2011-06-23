class PredictionValue < ActiveRecord::Base
  belongs_to :prediction
  has_paper_trail
  default_scope order('year')
end
