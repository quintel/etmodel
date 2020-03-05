class FixMeritOrderCostChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'local_chp_gas_merit_order' => '#E84118',
    'local_chp_wood_merit_order' => '#6AB04C',
    'industry_chp_wood_merit_order' => '#BADC58',
    'industry_chp_gas_engine_merit_order' => '#CED6E0',
    'industry_chp_gas_turbine_merit_order' => '#DFE4EA',
    'industry_chp_gas_ccgt_merit_order' => '#A4B0BE',
    'industry_chp_coal_merit_order' => '#485460',
    'waste_chp_merit_order' => '#006266',
  }

  def up
     ActiveRecord::Base.transaction do
      # Remove old series
      OutputElementSerie.find_by(gquery: 'central_biogas_chp_merit_order')&.destroy

      el = OutputElement.find_by_key(:merit_order)
      # Add new series
      create_output_series(el, 'industry_chp_coal_merit_order', 'industry_chp_coal_merit', 1)
      create_output_series(el, 'industry_chp_gas_ccgt_merit_order', 'industry_chp_gas_ccgt_merit', 1)
      create_output_series(el, 'industry_chp_gas_turbine_merit_order', 'industry_chp_gas_turbine_merit', 1)
      create_output_series(el, 'industry_chp_gas_engine_merit_order', 'industry_chp_gas_engine_merit', 1)
      create_output_series(el, 'industry_chp_wood_merit_order', 'industry_chp_wood_merit', 1)
      create_output_series(el, 'waste_chp_merit_order', 'waste_chp_merit', 1)
      create_output_series(el, 'local_chp_wood_merit_order', 'local_chp_wood_merit', 1)
      create_output_series(el, 'local_chp_gas_merit_order', 'local_chp_gas_merit', 1)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_output_series(element, gquery, label, order_by, target_line: false, group: '')
    element.output_element_series.create!(output_series_attrs(gquery, label, order_by, target_line, group))
  end

  def output_series_attrs(gquery, label, order_by, target_line, group)
      {
        color: COLORS[gquery],
        gquery: gquery,
        is_target_line: target_line,
        label: label,
        order_by: order_by,
        group: group
      }
  end
end
