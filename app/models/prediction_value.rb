class PredictionValue < ActiveRecord::Base
  belongs_to :prediction
  has_paper_trail
end
