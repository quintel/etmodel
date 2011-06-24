class Prediction < ActiveRecord::Base
  belongs_to :input_element
  has_many :prediction_values
  belongs_to :user
  
  has_paper_trail
  
  validates_associated :input_element, :user
  validates_presence_of :description , :message => "can't be blank"
  
end
