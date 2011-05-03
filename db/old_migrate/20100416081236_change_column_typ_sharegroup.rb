class ChangeColumnTypSharegroup < ActiveRecord::Migration
  def self.up
    change_column :input_elements, :share_group, :string
  end

  def self.down
    change_column :input_elements, :share_group, :integer
  end
end
