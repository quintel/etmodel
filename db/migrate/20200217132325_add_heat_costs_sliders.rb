class AddHeatCostsSliders < ActiveRecord::Migration[5.2]
  OLD_INPUTS = [
    'om_costs_heat_network_buildings',
    'investment_costs_heat_network_buildings',
    'om_costs_heat_network_households',
    'investment_costs_heat_network_households']

  def up
     ActiveRecord::Base.transaction do
      slide = Slide.find_by_key(:costs_heat_network)
      slide.update_attributes!(output_element_id: 254)
      slide_id = slide.id


      sliders = {
        'costs_heat_infra_indoors' => {
          'query' => 'costs_heat_infra_indoors',
          'step_value' => 1.0,
          'unit' => '%',
          'position' => 2,
          'description' => {
            'content_nl' => "Met deze schuif stel je de toe- of afname in die je verwacht voor de investeringskosten en onderhouds- en beheerkosten van inpandige warmte-infrastructuur voor collectieve warmtenetten. Voor appartementgebouwen rekenen we kosten voor inpandige leidingen, voor utiliteitsbouw inpandige leidingen en warmtemeters.",
            'content_en' => "This slider allows you to change future investment and O&M costs for indoor heating infrastructure for district heating networks. For apartment blocks and the services sector the ETM takes into account costs for indoor pipelines, for the services sector we also charge costs for indoor heat meters."
          },
          'options' => {}
        },
        'costs_heat_infra_outdoors' => {
          'query' => 'costs_heat_infra_outdoors',
          'step_value' => 1.0,
          'unit' => '%',
          'position' => 1,
          'description' => {
            'content_nl' => "Met deze schuif stel je de toe- of afname in die je verwacht voor de investeringskosten en onderhouds- en beheerkosten van de ondergrondse warmte-infrastructuur voor collectieve warmtenetten. Het ETM rekent kosten voor pijpleidingen (primair en secundair), overdrachtstations en onderstations.",
            'content_en' => "This slider allows you to change future investment and O&M costs for underground heating infrastructure for district heating networks. The ETM takes into account costs for pipelines (both primary and secondary distribution networks), heat exchanger stations and sub stations."
          },
          'options' => {}
        }
      }
      # Add new inputs
      sliders.each do |key, attrs|
        create_input_element(slide_id, attrs['query'], attrs['step_value'], attrs['unit'], attrs['position'], attrs['description'], attrs['options'])
      end
    end

    OLD_INPUTS.each do |key|
        InputElement.find_by(key: key).destroy!
      end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_input_element(slide_id, gquery, step_value, unit, position, description, options)
    # create slider
    input = InputElement.create!(input_element_attrs(slide_id, gquery, step_value, unit, position, options: options))
    # create tooltip
    Description.create!(
        describable_id: input.id,
        describable_type: 'InputElement',
        content_en: description['content_en'],
        content_nl: description['content_nl']
        )
  end

  def input_element_attrs(slide_id, gquery, step_value, unit, position, options: {})
    {
      slide_id: slide_id,
      key: gquery,
      step_value: step_value,
      unit: unit,
      position: position,
    }.merge(options)
  end
end
