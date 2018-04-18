class AddInterconectAndOffshoreToInvestmentChart < ActiveRecord::Migration[5.1]
  def change
    element = OutputElement.find_by_key!(:additional_infrastructure_investments)

    element.output_element_series.create(
      label: 'interconnection_net',
      order_by: 7,
      gquery: 'interconnection_net_in_additional_infrastructure_investments',
      color: '#696969'
    )

    element.output_element_series.create(
      label: 'offshore_net',
      order_by: 8,
      gquery: 'offshore_net_in_additional_infrastructure_investments',
      color: '#A9A9A9'
    )
  end

  def down
    element = OutputElement.find_by_key!(:additional_infrastructure_investments)

    element.output_element_series.where(gquery: %w[
      interconnection_net_in_additional_infrastructure_investments
      offshore_net_in_additional_infrastructure_investments
    ]).destroy_all
  end
end
