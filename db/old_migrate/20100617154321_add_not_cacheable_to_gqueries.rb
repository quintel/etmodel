class AddNotCacheableToGqueries < ActiveRecord::Migration
  def self.up
    add_column :gqueries, :not_cacheable, :boolean, :default => false
  end

  def self.down
    remove_column :gqueries, :not_cacheable
  end
end
