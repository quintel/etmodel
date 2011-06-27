class Prediction < ActiveRecord::Base
  belongs_to :input_element
  has_many :prediction_values
  belongs_to :user
  
  has_paper_trail
  
  validates_presence_of :input_element_id, :user_id , :description , :message => "can't be blank"
  
end
