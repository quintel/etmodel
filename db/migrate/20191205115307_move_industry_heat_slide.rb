class MoveIndustryHeatSlide < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      industry_slide = Slide.find_by_key(:supply_heat_network_industry)
      industry_slide.update_attributes!(sidebar_item_id: 4, position: 13, output_element_id: 251)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      industry_slide = Slide.find_by_key(:supply_heat_network_industry)
      industry_slide.update_attributes!(sidebar_item_id: 24, position: 3, output_element_id: 235)
    end
  end
end
