class CreateUserTracks < ActiveRecord::Migration
  def self.up
    create_table :user_tracks do |t|
      t.integer :user_id
      t.string :action
      t.string :key
      t.string :value

      t.timestamps
    end
    
    add_index :user_tracks, :user_id
    add_index :user_tracks, :action
  end

  def self.down
    drop_table :user_tracks
  end
end
