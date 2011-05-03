class AddComplexityToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :complexity, :integer
  end

  def self.down
    remove_column :slides, :complexity
  end
end
