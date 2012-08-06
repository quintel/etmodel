# == Schema Information
#
# Table name: output_element_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OutputElementType < ActiveRecord::Base
  BLOCK_CHART_ID = 8 # Ugly
  has_paper_trail

  has_many :output_elements, :dependent => :nullify

  def html_table?
    name == 'html_table'
  end
end

