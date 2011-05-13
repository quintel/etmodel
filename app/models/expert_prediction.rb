# == Schema Information
#
# Table name: expert_predictions
#
#  id               :integer(4)      not null, primary key
#  input_element_id :integer(4)
#  name             :string(255)
#  extra_key        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  key              :string(255)
#

class ExpertPrediction < ActiveRecord::Base
  has_one :input_element
  has_many :year_values, :as => :value_by_year
  has_paper_trail
end


