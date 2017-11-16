class AddPowerToKeroseneSlide < ActiveRecord::Migration[5.0]
  def up
    p2g = Slide.find_by_key!(:flexibility_flexibility_power_to_gas)

    # Reposition lower slides.
    Slide.where(sidebar_item: p2g.sidebar_item).each do |other|
      if other.position > p2g.position
        other.update_attributes!(position: other.position + 1)
      end
    end

    slide = Slide.create!(
      key: :flexibility_flexibility_power_to_kerosene,
      sidebar_item: p2g.sidebar_item,
      output_element: p2g.output_element,
      alt_output_element: p2g.alt_output_element,
      position: p2g.position + 1
    )

    InputElement.create!(
      key: :number_of_flexibility_p2l_electricity,
      slide: slide,
      step_value: 1,
      unit: '#'
    )
  end

  def down
    slide = Slide.find_by_key!(:flexibility_flexibility_power_to_kerosene)

    # Reposition lower slides.
    Slide.where(sidebar_item: slide.sidebar_item).each do |other|
      if other.position > slide.position
        other.update_attributes!(position: other.position - 1)
      end
    end

    slide.destroy
    InputElement.find_by_key!(:number_of_flexibility_p2l_electricity).destroy
  end
end
