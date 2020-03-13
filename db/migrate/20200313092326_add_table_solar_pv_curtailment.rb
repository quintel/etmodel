class AddTableSolarPvCurtailment < ActiveRecord::Migration[5.2]
  def up
    type = OutputElementType.create!(name: 'html_table')

    chart = OutputElement.create!(
      key: 'solar_pv_curtailment',
      output_element_type: type,
      group: 'Merit',
      sub_group: 'flexibility'
    )

  end

  def down
    OutputElement.find_by(key: 'solar_pv_curtailment').destroy!
  end
  end
