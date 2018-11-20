class AddRelatedOutputElementAssociationToOutputElement < ActiveRecord::Migration[5.2]
  def change
    add_reference :output_elements, :related_output_element
  end
end
