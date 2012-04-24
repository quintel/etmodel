class CreateBlueprintModels < ActiveRecord::Migration
  def self.up
    create_table :blueprint_models do |t|
      t.string :title
      t.timestamps
    end
    add_column :blueprints, :blueprint_model_id, :integer

    b = BlueprintModel.create(:title => "ETM")
    Blueprint.update_all("blueprint_model_id = #{b.id}")
  end

  def self.down
    remove_column :blueprints, :blueprint_model_id
    drop_table :blueprint_models
  end
end