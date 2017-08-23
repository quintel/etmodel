class UpdateBufferSliderStepSize < ActiveRecord::Migration[5.0]
  def up
    inputs.update_all(step_value: 0.5)
  end

  def down
    inputs.update_all(step_value: 1.0)
  end

  private

  def inputs
    InputElement.where(key: %i[
      households_flexibility_space_heating_buffer_size
      households_flexibility_water_heating_buffer_size
    ])
  end
end
