# == Schema Information
#
# Table name: output_element_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OutputElementType < YModel::Base
  index_on :name
  has_many :output_elements

  def html_table?
    name == 'html_table'
  end
end

