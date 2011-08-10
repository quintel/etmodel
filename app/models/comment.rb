# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_id   :integer(4)
#  commentable_type :integer(4)
#  user_id          :integer(4)
#  email            :string(255)
#  name             :string(255)
#  title            :string(255)
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  validates :body, :presence => true
  
  attr_accessible :body, :name, :email
  
  scope :recent_first, order('created_at DESC')
  
  def author_name
    if user
      user.name
    elsif name
      name
    else
      "[anonymous]"
    end
  end
end
