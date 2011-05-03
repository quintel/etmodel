class HistoricSerie < ActiveRecord::Base
  has_paper_trail
  has_many :year_values, :as => :value_by_year
end

# == Schema Information
#
# Table name: historic_series
#
#  id         :integer(4)      not null, primary key
#  key        :string(255)
#  area_code  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

