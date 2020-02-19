class AddIndustrialResidualHeatSliders < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      slide = Slide.find_by_key(:supply_heat_sources)
      slide_id = slide.id

      sliders = {
        'residual_heat_chemicals_other' => {
          'query' => 'share_of_industry_chemicals_other_reused_residual_heat',
          'step_value' => 1,
          'unit' => '%',
          'position' => 3,
          'description' => {
            'content_nl' => "Hoeveel procent van de beschikbare restwarmte uit de chemische industrie wil je uitkoppelen? Hoe de restwarmte potentie is bepaald, is te lezen in onze documentatie. Vaak wordt er niet meer dan 10-20% van de beschikbare warmte uitgekoppeld in verband met korte termijn restricties en strategische overwegingen.",
            'content_en' => "What percentage of the available residual heat from the chemical industry do you want to use in heat networks? How the residual heat potential is determined can be read in our documentation. Often no more than 10-20% of the available heat is used due to short-term restrictions and strategic considerations."
          },
          'options' => {
            'interface_group' => 'residual_heat'
          }
        },
        'residual_heat_chemicals_refineres' => {
          'query' => 'share_of_industry_chemicals_fertilizers_reused_residual_heat',
          'step_value' => 1,
          'unit' => '%',
          'position' => 3,
          'description' => {
            'content_nl' => "Hoeveel procent van de beschikbare restwarmte uit de kunstmestindustrie wil je uitkoppelen? Hoe de restwarmte potentie is bepaald, is te lezen in onze documentatie. Vaak wordt er niet meer dan 10-20% van de beschikbare warmte uitgekoppeld in verband met korte termijn restricties en strategische overwegingen.",
            'content_en' => "What percentage of the available residual heat from the fertilizer industry do you want to use in heat networks? How the residual heat potential is determined can be read in our documentation. Often no more than 10-20% of the available heat is used due to short-term restrictions and strategic considerations."
          },
          'options' => {
            'interface_group' => 'residual_heat'
          }
        },
        'residual_heat_chemicals_refineries' => {
          'query' => 'share_of_industry_chemicals_refineries_reused_residual_heat',
          'step_value' => 1,
          'unit' => '%',
          'position' => 3,
          'description' => {
            'content_nl' => "Hoeveel procent van de beschikbare restwarmte uit raffinaderijen wil je uitkoppelen? Hoe de restwarmte potentie is bepaald, is te lezen in onze documentatie. Vaak wordt er niet meer dan 10-20% van de beschikbare warmte uitgekoppeld in verband met korte termijn restricties en strategische overwegingen.",
            'content_en' => "What percentage of the available residual heat from refineries do you want to use in heat networks? How the residual heat potential is determined can be read in our documentation. Often no more than 10-20% of the available heat is used due to short-term restrictions and strategic considerations."
          },
          'options' => {
            'interface_group' => 'residual_heat'
          }
        },
        'residual_heat_other_ict' => {
          'query' => 'share_of_industry_other_ict_reused_residual_heat',
          'step_value' => 1,
          'unit' => '%',
          'position' => 3,
          'description' => {
            'content_nl' => "Hoeveel procent van de beschikbare restwarmte uit datacenters wil je uitkoppelen? Hoe de restwarmte potentie is bepaald, is te lezen in onze documentatie. Vaak wordt er niet meer dan 10-20% van de beschikbare warmte uitgekoppeld in verband met korte termijn restricties, strategische overwegingen en alternatieven die nu al beter voor bedrijven zijn.",
            'content_en' => "What percentage of the available residual heat from datacenters do you want to use in heat networks? How the residual heat potential is determined can be read in our documentation. Often no more than 10-20% of the available heat is used due to short-term restrictions, strategic considerations and alternatives that are already better for companies."
          },
          'options' => {
            'interface_group' => 'residual_heat'
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
