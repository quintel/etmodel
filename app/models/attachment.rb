class Attachment < ActiveRecord::Base
  has_attached_file :file
  belongs_to :attachable, :polymorphic => true
  
  attr_accessible :file, :title

end

# == Schema Information
#
# Table name: attachments
#
#  id                :integer(4)      not null, primary key
#  attachable_id     :integer(4)
#  attachable_type   :string(255)
#  title             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :string(255)
#  file_updated_at   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

