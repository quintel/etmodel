class AddDataVisualsSlides < ActiveRecord::Migration[5.1]
  SLIDES_YAML = <<-YAML.strip_heredoc
  ---
  - key: data_visuals_scenario_report
    position: 1
    output_element_key: households_final_demand_per_application
    description_attributes:
      content_en: |
        The scenario report is a printable description of the decisions you made in your current scenario, progress made towards important goals, and includes charts showing breakdowns of energy use, electricity production, and much more.

        <ul class="data-download">
          <li><a href="/scenario/reports/main"><span class="fa fa-book"></span> View the report →</a></li>
        </ul>
      content_nl: |
        Het scenarioverslag beschrijft je scenario in woord en beeld. Het bevat informatie over de behaalde doelen, toont uitsplitsingen van energiegebruik en elektriciteitsproductie, wijst je op mogelijke inconsistenties en nog veel meer.

        <ul class="data-download">
          <li><a href="/scenario/reports/main"><span class="fa fa-book"></span> View the report →</a></li>
        </ul>

  - key: data_visuals_factsheet
    position: 2
    output_element_key: households_final_demand_per_application
    description_attributes:
      content_en: |
        A printable A3 or A4 factsheet describing how energy is produced and consumed in your scenario. Unfortunately, the factsheet is currently available in Dutch only.

        <ul class="data-download">
          <li><a href="/scenarios/%{scenario_id}/factsheet"><span class="fa fa-newspaper-o"></span> View the factsheet →</a></li>
        </ul>
      content_nl: |
        Een printklare A3 'factsheet' waarin de energie-mix voor zowel vraag als aanbod wordt samengevat voor je scenario.

        <ul class="data-download">
          <li><a href="/scenarios/%{scenario_id}/factsheet"><span class="fa fa-newspaper-o"></span> View the factsheet →</a></li>
        </ul>

  - key: data_visuals_graph
    position: 3
    output_element_key: households_final_demand_per_application
    description_attributes:
      content_en: |
        A detailed breakdown of energy flows throughout the Energy Transition Model for your scenario. Recommended only for advanced users.

        <ul class="data-download">
          <li><a href="%{etengine_url}/data/%{scenario_id}/layout"><span class="fa fa-object-group"></span> View the graph →</a></li>
        </ul>
      content_nl: |
        A detailed breakdown of energy flows throughout the Energy Transition Model for your scenario. Recommended only for advanced users.

        <ul class="data-download">
          <li><a href="%{etengine_url}/data/%{scenario_id}/layout"><span class="fa fa-object-group"></span> View the graph →</a></li>
        </ul>
  YAML

  def up
    si = SidebarItem.create!(
      tab: Tab.find_by_key!(:data),
      key: 'data_visuals',
      section: 'data',
      position: 2
    )

    # Remove any orphaned records with the same ID.
    si.description.try(:destroy)
    si.area_dependency.try(:destroy)

    si.slides.each do |slide|
      slide.sliders.destroy_all
      slide.destroy
    end

    YAML.load(SLIDES_YAML).each do |slide_data|
      oe = OutputElement.find_by_key!(slide_data.delete('output_element_key'))
      Slide.create!(slide_data.merge(output_element: oe, sidebar_item: si))
    end
  end

  def down
    SidebarItem.find_by_key!('data_visuals').destroy
    Slide.where(key: YAML.load(SLIDES_YAML).pluck('key')).destroy_all
  end
end
