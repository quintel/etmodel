class CreateHistoricSerieDatas < ActiveRecord::Migration
  def self.up
    create_table :historic_serie_datas do |t|
      t.integer :historic_serie_id
      t.integer :year
      t.float :value

      t.timestamps
    end
  end

  def self.down
    drop_table :historic_serie_datas
  end
end
