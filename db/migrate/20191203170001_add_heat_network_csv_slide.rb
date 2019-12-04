class AddHeatNetworkCsvSlide < ActiveRecord::Migration[5.2]
  def up
    sidebar_item  = SidebarItem.find_by_key('data_export')

    Slide.create!(
      key: 'data_export_heat_network',
      sidebar_item: sidebar_item,
      output_element: OutputElement.find_by_key(:heat_network_demand),
      position: sidebar_item.slides.ordered.last.position + 1,
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
          Download information about the hourly demands and supplies of heat
          through the central heat network for households, buildings and agriculture.

          <ul class="data-download">
            <li>
              <a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/heat_network.csv">
                <span class="fa fa-download"></span>
                Heat network curves
                <span class="filetype">(1.5MB CSV)</span>
              </a>
            </li>
          </ul>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          Download informatie over de uurlijkse vraag en productie van collectieve
          warmte voor warmtenetten in huishoudens, gebouwen en landbouw.

          <ul class="data-download">
            <li>
              <a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/heat_network.csv">
                <span class="fa fa-download"></span>
                Warmtenetcurves
                <span class="filetype">(1.5MB CSV)</span>
              </a>
            </li>
          </ul>
        TXT
      }
    )
  end

  def down
    Slide.find_by_key('data_export_heat_network').destroy
  end
end
