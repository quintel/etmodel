class AddDefaultOutputElementValues < ActiveRecord::Migration
  def up
    change_column :output_element_series, :order_by, :integer, default: 1

    change_column :output_elements, :output_element_type_id, :integer, null: false
    change_column :output_elements, :under_construction,     :boolean, default: false
    change_column :output_elements, :percentage,             :boolean, default: false
    change_column :output_elements, :show_point_label,       :boolean, default: false
    change_column :output_elements, :growth_chart,           :boolean, default: false
    change_column :output_elements, :key,                    :string,  null: false
  end

  def down
    change_column :output_element_series, :order_by, :integer, default: nil

    change_column :output_elements, :output_element_type_id, :integer, null: true
    change_column :output_elements, :under_construction,     :boolean
    change_column :output_elements, :percentage,             :boolean
    change_column :output_elements, :show_point_label,       :boolean
    change_column :output_elements, :growth_chart,           :boolean
    change_column :output_elements, :key,                    :string,  null: true
  end
end
