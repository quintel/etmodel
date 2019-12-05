class RemoveP2hFromHourlyFlexChart < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      OutputElementSerie.find_by(gquery: 'households_flexibility_p2h_electricity').destroy!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end