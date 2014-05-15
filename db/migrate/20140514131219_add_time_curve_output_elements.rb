class AddTimeCurveOutputElements < ActiveRecord::Migration
  def up
    type = OutputElementType.create!(name: 'time_curve')
    coal = create_element!(type, :production_curve_coal)
    oil  = create_element!(type, :production_curve_crude_oil)
    gas  = create_element!(type, :production_curve_natural_gas)
    bio  = create_element!(type, :production_curve_bio_residues_for_firing)
    uran = create_element!(type, :production_curve_uranium)

    # Coal Series

    coal.output_element_series.create!(
      gquery: :production_curve_coal, label: :coal,
      color: Colors::COLORS['coal_black'])

    coal.output_element_series.create!(
      gquery: :production_curve_lignite, label: :lignite,
      color: Colors::COLORS['lignite_grey'], order_by: 2)

    # Oil Series

    oil.output_element_series.create!(
      gquery: :production_curve_crude_oil, label: :crude_oil,
      color: Colors::COLORS['oil_brown'])

    # Gas Series

    gas.output_element_series.create!(
      gquery: :production_curve_natural_gas, label: :natural_gas,
      color: Colors::COLORS['gas_grey'])

    # Bio-residues Series

    bio.output_element_series.create!(
      gquery: :production_curve_bio_residues_for_firing, label: :biomass,
      color: Colors::COLORS['biomass_green'])

    # Uranium Series

    uran.output_element_series.create!(
      gquery: :production_curve_uranium, label: :uranium,
      color: Colors::COLORS['nuclear_orange'])
  end

  def down
    destroy!(OutputElement, key: :production_curve_coal)
    destroy!(OutputElement, key: :production_curve_crude_oil)
    destroy!(OutputElement, key: :production_curve_natural_gas)
    destroy!(OutputElement, key: :production_curve_bio_residues_for_firing)
    destroy!(OutputElement, key: :production_curve_uranium)

    destroy!(OutputElementType, name: :time_curve)
  end

  #######
  private
  #######

  def create_element!(type, key)
    OutputElement.create!(
      key: key, output_element_type: type, unit: 'PJ', group: 'Supply')
  end

  def destroy!(klass, conditions)
    klass.where(conditions).first.destroy!
  end
end
