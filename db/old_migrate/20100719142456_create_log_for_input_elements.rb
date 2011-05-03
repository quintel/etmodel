class CreateLogForInputElements < ActiveRecord::Migration
  def self.up
    create_table :user_logs do |t|
      t.string  :ip
      t.integer :complexity
      t.string  :region
      t.string  :locale
      t.string  :log_type
      t.integer :log_type_id
      t.float   :value
      t.timestamps
    end
  end

  def self.down
    drop_table :user_logs
  end
end
