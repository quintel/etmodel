class AddRequiresMeritOrderToOutputElements < ActiveRecord::Migration
  def change
    add_column :output_elements, :requires_merit_order, :boolean, default: false

    OutputElement.where(id: [163,164]).update_all(requires_merit_order: true)
  end
end
