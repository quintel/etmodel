class CreateAreaDependencies < ActiveRecord::Migration
  def self.up
    create_table :area_dependencies do |t|
      t.string :dependent_on
      t.text :description
      t.references :dependable, :polymorphic => true
    end
  end

  def self.down
    drop_table :area_dependencies
  end
end
