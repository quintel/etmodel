class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.integer :commentable_type
      t.integer :user_id
      t.string :email
      t.string :name
      t.string :title
      t.text :body
      t.timestamps
    end
    
    add_index :comments, [:commentable_type, :commentable_id]
    add_index :comments, :user_id
  end

  def self.down
    drop_table :comments
  end
end
