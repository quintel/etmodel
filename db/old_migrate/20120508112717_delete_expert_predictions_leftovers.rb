class DeleteExpertPredictionsLeftovers < ActiveRecord::Migration
  def up
   YearValue.destroy_all :value_by_year_type => 'ExpertPrediction'
  end

  def down
  end
end
