class HistoricSerieEntry < ActiveRecord::Base
  has_paper_trail
  belongs_to :historic_serie
end

# == Schema Information
#
# Table name: historic_serie_entries
#
#  id                :integer(4)      not null, primary key
#  historic_serie_id :integer(4)
#  year              :integer(4)
#  value             :float
#  created_at        :datetime
#  updated_at        :datetime
#

