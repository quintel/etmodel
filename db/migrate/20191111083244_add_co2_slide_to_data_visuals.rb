class AddCo2SlideToDataVisuals < ActiveRecord::Migration[5.2]
  def change
    Slide.create!(
      key: 'data_visuals_co2_sheet',
      sidebar_item: SidebarItem.find_by_key!(:data_visuals),
      output_element: OutputElement.find_by_key(:households_final_demand_per_application),
      position: 4,
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
          A printable sheet depicting the CO<sub>2</sub> footprint for your scenario.
            <ul class="data-download">
              <li><a href="%{api_url}/regions/%{area_code}?time=future&scenario=true" target="_blank"><span class="fa fa-newspaper-o"></span> View the sheet →</a></li>
            </ul>
          TXT
        content_nl: <<-TXT.strip_heredoc,
          Een printklare sheet met een visuele samenvatting van de CO<sub>2</sub>-voetafdruk voor jouw scenario.
          <ul class="data-download">
            <li><a href="%{api_url}/regions/%{area_code}?time=future&scenario=true" target="_blank"><span class="fa fa-newspaper-o"></span> Bekijk de sheet →</a></li>
          </ul>
        TXT
      }
    )
  end
end
