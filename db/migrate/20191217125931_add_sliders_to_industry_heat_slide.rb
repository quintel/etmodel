class AddSlidersToIndustryHeatSlide < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      slide = Slide.find_by_key(:supply_heat_network_industry)
      slide_id = slide.id

      sliders = {
        'wood_pellets_chp' => {
          'query' => 'capacity_of_industry_chp_wood_pellets',
          'step_value' => 1,
          'unit' => 'MW',
          'position' => 5,
          'description' => {
            'content_nl' => "Een WKK produceert zowel warmte als elektriciteit. In de industrie is deze warmte vaak in de vorm van stoom. Kies hier het vermogen aan biomassa-WKKs dat levert aan het industriële stoomnetwerk.",
            'content_en' => "A CHP produces electricity and heat. In the industry sector this heat is very often stored in steam. Here you can choose the capacity of wood pellet CHPs delivering to the industrial steam network."
          },
          'options' => {
            'related_converter' => 'industry_chp_wood_pellets'
          }
        },
        'coal_heater' => {
          'query' => 'capacity_of_industry_heat_burner_coal',
          'step_value' => 1,
          'unit' => 'MW',
          'position' => 6,
          'description' => {
            'content_nl' => "Een ketel produceert warmte. In de industrie is deze warmte vaak in de vorm van stoom. Kies hier het vermogen aan kolenketels dat levert aan het industriële stoomnetwerk.",
            'content_en' => "A burner produces heat. In the industry sector this heat is very often stored in steam. Here you can choose the capacity of coal burner delivering to the industrial steam network.”"
          },
          'options' => {
            'related_converter' => 'industry_heat_burner_coal'
          }
        },
        'oil_heater' => {
          'query' => 'capacity_of_industry_heat_burner_crude_oil',
          'step_value' => 1,
          'unit' => 'MW',
          'position' => 7,
          'description' => {
            'content_nl' => "Een ketel produceert warmte. In de industrie is deze warmte vaak in de vorm van stoom. Kies hier het vermogen aan olieketels dat levert aan het industriële stoomnetwerk.",
            'content_en' => "A burner produces heat. In the industry sector this heat is very often stored in steam. Here you can choose the capacity of oil burners delivering to the industrial steam network.”"
          },
          'options' => {
            'related_converter' => 'industry_heat_burner_crude_oil'
          }
        },
        'lignite_heater' => {
          'query' => 'capacity_of_industry_heat_burner_lignite',
          'step_value' => 1,
          'unit' => 'MW',
          'position' => 8,
          'description' => {
            'content_nl' => "Een ketel produceert warmte. In de industrie is deze warmte vaak in de vorm van stoom. Kies hier het vermogen aan bruinkoolketels dat levert aan het industriële stoomnetwerk.",
            'content_en' => "A burner produces heat. In the industry sector this heat is very often stored in steam. Here you can choose the capacity of lignite burners delivering to the industrial steam network.”"
          },
          'options' => {
            'related_converter' => 'industry_heat_burner_lignite'
          }
        },
        'geothermal' => {
          'query' => 'capacity_of_industry_heat_well_geothermal',
          'step_value' => 1,
          'unit' => 'MW',
          'position' => 9,
          'description' => {
            'content_nl' => "Geothermie maakt gebruik van warmte uit de bodem. Voor de industrie is deze warmte vaak een té lage temperatuur. Toch is het in sommige sectoren inzetbaar, zoals de papier- en voedselindustrie. Kies hier het vermogen aan geothermieputten dat warmte levert aan de industrie.",
            'content_en' => "Geothermal heat wells extract heat from the earth. In many cases the temperature of this heat is too low for industrial processes. However, in some sectors like Food and Paper geothermal heat could be an interesting heat source. Here you can choose the capacity of geothermal wells delivering heat to the industry sector.”"
          },
          'options' => {
            'related_converter' => 'industry_heat_well_geothermal'
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
