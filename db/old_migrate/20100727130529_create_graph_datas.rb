class CreateGraphDatas < ActiveRecord::Migration
  def self.up
    create_table :graph_datas, :force => true do |t|
      t.integer :blueprint_id
      t.string :region_code

      t.timestamps
    end
  end

  def self.down
    drop_table :graph_datas
  end
end
