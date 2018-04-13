class UpdateAdditionalInfrastructureChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.find_by_key!(:additional_infrastructure_investments)

    chart.output_element_series.find_by_label!('mv_distribution').destroy!

    chart.output_element_series
      .find_by_label!(:mv_transport)
      .update_attributes!(
        label: 'mv_net',
        gquery: 'mv_net_in_additional_infrastructure_investments'
      )

    chart.output_element_series
      .find_by_label!(:lv_mv_transformer).update_attributes!(color: '#5D7929')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
