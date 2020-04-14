# == Schema Information
#
# Table name: output_element_types
#
#  name       :string(255)
#
class OutputElementType < YModel::Base
  index_on :name
  source_file 'config/interface/output_element_types.yml'
  has_many :output_elements

  def html_table?
    name == 'html_table'
  end
end
