class RenameDemandResponseSlide < ActiveRecord::Migration[5.0]
  def up
    slide =
      Slide.find_by_key(:flexibility_flexibility_demand_response) ||
      Slide.find_by_key(:flexibility_flexibility_demand_response_EV)

    # Nevermind if it has already been renamed.
    if slide
      slide.update_attributes!(key: :flexibility_flexibility_demand_response_ev)
    end
  end

  def down
    slide = Slide.find_by_key(:flexibility_flexibility_demand_response_ev)
    slide.update_attributes!(key: :flexibility_flexibility_demand_response)
  end
end
