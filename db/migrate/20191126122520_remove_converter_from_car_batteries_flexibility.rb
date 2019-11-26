class RemoveConverterFromCarBatteriesFlexibility < ActiveRecord::Migration[5.2]
  def up
    slider.update!(related_converter: '')
  end

  def down
    slider.update!(related_converter: 'transport_car_flexibility_p2p_electricity')
  end

  private

  def slider
    InputElement.find_by_key('transport_car_using_electricity_availability')
  end
end
