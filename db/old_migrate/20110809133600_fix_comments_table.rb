class FixCommentsTable < ActiveRecord::Migration
  def self.up
    change_column :comments, :commentable_type, :string
    
    Comment.reset_column_information
    Comment.update_all(:commentable_type => 'Prediction')
  end

  def self.down
  end
end
