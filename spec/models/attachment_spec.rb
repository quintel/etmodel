require 'spec_helper'

describe Attachment do
  pending "add some examples to (or delete) #{__FILE__}" 
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

