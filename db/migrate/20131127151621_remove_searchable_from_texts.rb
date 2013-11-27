class RemoveSearchableFromTexts < ActiveRecord::Migration
  def up
    remove_column :texts, :searchable
  end

  def down
    add_column :texts, :searchable, :boolean

    Text.reset_column_information

    values = {
      fce_coal:            false,
      fce_naturalgas:      false,
      fce_uranium:         false,
      fce_biomass:         false,
      fce_greengas:        false,
      fce_oil:             false,
      fce_liquid_biofuels: false,
      partner_info:        true,
      quality_control:     true
    }

    Text.all.each do |text|
      text.searchable = values[text.key.to_sym]
      text.save(validate: false)
    end
  end
end
