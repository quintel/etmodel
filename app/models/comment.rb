class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  validates :body, :presence => true
  
  attr_accessible :body, :name, :email
  
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
