class AddTableHybridHeatPump < ActiveRecord::Migration[5.2]
  def up
    type = OutputElementType.create!(name: 'html_table')

    chart = OutputElement.create!(
      key: 'hybrid_heat_pump',
      output_element_type: type,
      group: 'Demand',
      sub_group: 'households',
      related_output_element_id: '258'
    )

  end

  def down
    OutputElement.find_by(key: 'hybrid_heat_pump').destroy!
  end
  end
