class CreatePressReleases < ActiveRecord::Migration
  def self.up
    create_table :press_releases do |t|
      t.string :medium
      t.string :release_type
      t.datetime :release_date
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :press_releases
  end
end
