class AddBlueprintLayoutIdToConverterPositions < ActiveRecord::Migration
  def self.up
    add_column :converter_positions, :blueprint_layout_id, :integer
    bp = BlueprintLayout.create :key => 'ETM'
    BlueprintLayout.create :key => 'ETM_2'
    ConverterPosition.update_all("blueprint_layout_id = #{bp.id}")
  end

  def self.down
    remove_column :converter_positions, :blueprint_layout_id
  end
end
