class AddDataSidebar < ActiveRecord::Migration[5.0]
  def up
    data_tab = Tab.create!(key: 'data', position: 6)

    data_si  = SidebarItem.create!(
      key: :data_export,
      tab: data_tab,
      section: :data,
      position: 1,
      description_attributes: {
        content_en: 'Download information about your scenario, such as merit order price and load curves, and application demands.',
        short_content_en: 'Download information about your scenario',
        content_nl: 'Download informatie over je scenario, zoals draaiprofielen en de prijscurve uit de merit order berekening en de vraag per toepassing.',
        short_content_nl: 'Download informatie over je scenario.'
      }
    )

    # TODO SidebarItem texts

    # Update "Merit order data" slide

    mo_data = Slide.find_by_key(:flexibility_merit_order_merit_order_price)
    mo_data.update_attributes!(sidebar_item: data_si, position: 1)

    desc = mo_data.description

    desc.content_en = desc.content_en.gsub(
      '<ul class="merit-data-downloads">',
      '<ul class="data-download merit-data-downloads">'
    )

    desc.content_nl = desc.content_nl.gsub(
      '<ul class="merit-data-downloads">',
      '<ul class="data-download merit-data-downloads">'
    )

    desc.save!

    # Add "Application demands" slide

    Slide.create!(
      key: 'data_export_application_demands',
      sidebar_item: data_si,
      output_element: OutputElement.find_by_key(:use_of_primary_energy),
      position: 2,
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
          Download information about the primary and final demands, and also the primary CO<sub>2</sub> emissions of applications (such as cooking, appliances, heating, transport, etc).
          <ul class="data-download">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/application_demands.csv"><span class="fa fa-download"></span> Application primary and final demands <span class="filetype">(40KB CSV)</span></a></li>
          </ul>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          Download informatie over de primaire en finale vraag – en de primaire CO<sub>2</sub>-uitstoot – van toepassingen van energie (zoals koken, apparaten, ruimterverwarming en transport).
          <ul class="data-download">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/application_demands.csv"><span class="fa fa-download"></span> Primaire en finale vraag per toepassing <span class="filetype">(40KB CSV)</span></a></li>
          </ul>
        TXT
      }
    )

    # Add "Production parameters" slide

    Slide.create!(
      key: 'data_export_production',
      sidebar_item: data_si,
      output_element: OutputElement.find_by_key(:investment_table),
      position: 3,
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
        Download details of heat and electricity producers. Includes information about the electrical and heat capacities, number of units, and costs.
        <ul class="data-download">
          <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/production_parameters.csv"><span class="fa fa-download"></span> Production capacity and costs <span class="filetype">(15KB CSV)</span></a></li>
        </ul>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          Download details over de technologieën die elektriciteit en warmte produceren. Bevat informatie over de elektrische en warmtecapaciteit, het aantal opgestelde eenheden en de kosten.
          <ul class="data-download">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/production_parameters.csv"><span class="fa fa-download"></span> Capaciteiten en kosten <span class="filetype">(15KB CSV)</span></a></li>
          </ul>
        TXT
      }
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
