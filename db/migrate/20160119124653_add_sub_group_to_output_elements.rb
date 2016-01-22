class AddSubGroupToOutputElements < ActiveRecord::Migration
  def change
    add_column :output_elements, :sub_group, :string, after: :group
  end
end
