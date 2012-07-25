class DropInterfaceTable < ActiveRecord::Migration
  def self.up
    drop_table :interfaces
  end

  def self.down
    create_table "interfaces", :force => true do |t|
      t.string   "key"
      t.text     "structure"
      t.boolean  "enabled"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "interfaces", ["enabled"]
    add_index "interfaces", ["key"]
  end
end
