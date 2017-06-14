class RemoveRefineryOutputElementType < ActiveRecord::Migration[5.0]
  def up
    refinery_oe = OutputElementType.find_by_name!('refinery')
    sankey_oe   = OutputElementType.find_by_name!('sankey')

    refinery_oe.output_elements.each do |oe|
      oe.output_element_type = sankey_oe
      oe.save(validate: false)
    end

    refinery_oe.destroy
  end

  def down
    refinery_oe = OutputElementType.create(name: 'refinery')

    OutputElement.where(key: %w[refinery co2_sankey]).each do |oe|
      oe.output_element_type = refinery_oe
      oe.save(validate: false)
    end
  end
end
