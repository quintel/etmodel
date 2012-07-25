class RemoveCostAndResidaulFromConverterInfo < ActiveRecord::Migration
  def up
     OutputElementSerie.where(' id IN ( 647,649,653,655,671,673,659,661,665,667,696,692)').each do |i|
       i.destroy
     end
     OutputElementSerie.where(' id IN ( 648,654,672,660,666,697)').each do |j|
      value = j.order_by - 1
      j.update_attribute :order_by , value
     end

  end

  def down
  end
end
