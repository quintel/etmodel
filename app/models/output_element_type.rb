# == Schema Information
#
# Table name: output_element_types
#
#  name       :string(255)
#
class OutputElementType < YModel::Base
  index_on :name
  has_many :output_elements

  def html_table?
    name == 'html_table'
  end
end
