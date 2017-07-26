class AddHpDemandResponseSliders < ActiveRecord::Migration[5.0]
  def up
    if hp = Slide.find_by_key('flexibility_flexibility_demand_response_HP')
      hp.key = hp.key.downcase
      hp.save!
    else
      slide = Slide.create!(
        key: 'flexibility_flexibility_demand_response_hp',
        position: 9,
        sidebar_item: SidebarItem.find_by_key('electricity_storage'),
        output_element: OutputElement.find_by_key('dynamic_demand_curve')
      )

      InputElement.create!(
        slide: slide,
        key: 'households_flexibility_space_heating_buffer_size',
        step_value: 1.0,
        unit: 'kWh',
        interface_group: 'flexibility_buffers',
        position: 1
      )

      InputElement.create!(
        slide: slide,
        key: 'households_flexibility_water_heating_buffer_size',
        step_value: 1.0,
        unit: 'kWh',
        interface_group: 'flexibility_buffers',
        position: 2
      )
    end
  end

  def down
    InputElement.find_by_key('households_flexibility_water_heating_buffer_size').destroy
    InputElement.find_by_key('households_flexibility_space_heating_buffer_size').destroy
    Slide.find_by_key('flexibility_flexibility_demand_response_hp').destroy
  end
end
