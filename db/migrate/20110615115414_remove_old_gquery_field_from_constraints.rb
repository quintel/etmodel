class RemoveOldGqueryFieldFromConstraints < ActiveRecord::Migration
  def self.up
    remove_column :constraints, :query
  end

  def self.down
    add_column :constraints, :query, :string
  end
end
