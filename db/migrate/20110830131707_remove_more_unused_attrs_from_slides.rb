class RemoveMoreUnusedAttrsFromSlides < ActiveRecord::Migration
  def self.up
    remove_column :slides, :order_by
  end

  def self.down
    add_column :slides, :order_by, :integer
  end
end
