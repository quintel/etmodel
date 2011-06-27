class Prediction < ActiveRecord::Base
  belongs_to :input_element
  has_many :prediction_values
  has_many :prediction_measures
  
  belongs_to :user
  
  has_paper_trail
    
end
