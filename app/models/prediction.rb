class Prediction < ActiveRecord::Base
  has_one :input_element
  has_many :prediction_values
  belongs_to :user
  has_paper_trail
end
