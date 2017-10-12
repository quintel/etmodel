class AddEnergyFlowCsvSlide < ActiveRecord::Migration[5.0]
  def up
    sidebar_item  = SidebarItem.find_by_key('data_export')

    # Add "Application demands" slide

    Slide.create!(
      key: 'data_export_energy_flows',
      sidebar_item: sidebar_item,
      output_element: OutputElement.find_by_key(:sankey),
      position: 4,
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
          The Energy Transition Model describes the energy flows through several
          hundred uses and conversions; this CSV provides a list of each of
          these flows (inputs and outputs).
          <ul class="data-download">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/energy_flow.csv"><span class="fa fa-download"></span> Energy flows <span class="filetype">(375KB CSV)</span></a></li>
          </ul>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          The Energy Transition Model describes the energy flows through several
          hundred uses and conversions; this CSV provides a list of each of
          these flows (inputs and outputs).
          <ul class="data-download">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/energy_flow.csv"><span class="fa fa-download"></span> Energy flows <span class="filetype">(375KB CSV)</span></a></li>
          </ul>
        TXT
      }
    )
  end

  def down
    Slide.find_by_key('data_export_energy_flows').destroy
  end
end
