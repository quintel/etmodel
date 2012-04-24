class ExternalUserTracks < ActiveRecord::Migration
  def self.up
    change_column :users, :trackable, :string
    drop_table :user_tracks
    User.update_all(:trackable => nil)
  end

  def self.down
    change_column :users, :trackable, :boolean, :default => false
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
end
