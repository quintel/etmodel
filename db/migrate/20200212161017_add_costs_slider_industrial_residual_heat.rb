class AddCostsSliderIndustrialResidualHeat < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      slide = Slide.find_by_key(:costs_residual_heat)
      slide_id = slide.id

      sliders = {
        'costs_industry_residual_heat' => {
          'query' => 'costs_industry_residual_heat',
          'step_value' => 1.0,
          'unit' => '%',
          'position' => 0,
          'description' => {
            'content_nl' => "Met deze schuif stel je de toe- of afname in die je verwacht voor de investeringskosten en onderhouds- en beheerkosten van het uitkoppelen van industriële restwarmte. De kosten worden vergeleken met de kosten van vandaag de dag. De kosten in de link hieronder zijn de kosten die we hanteren voor restwarmte uit de chemische industrie, raffinaderijen en kunstmestindustrie. Voor lage temperatuur restwarmte uit datacenters rekenen we met andere kosten.",
            'content_en' => "This slider sets the change in future investment and O&M costs for residual heat from all industrial sectors. Costs are compared to current costs. The costs in the link below depict the costs that are used for residual heat from the chemical industry, refineries and fertilizer industry. For low temperature heat from datacenters we use different costs."
          },
          'options' => {
            'related_converter' => 'energy_heat_industry_chemicals_other_residual_heat'
          }
        }
      }
      # Add new inputs
      sliders.each do |key, attrs|
        create_input_element(slide_id, attrs['query'], attrs['step_value'], attrs['unit'], attrs['position'], attrs['description'], attrs['options'])
      end
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
