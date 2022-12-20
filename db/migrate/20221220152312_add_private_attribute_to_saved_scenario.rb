class AddPrivateAttributeToSavedScenario < ActiveRecord::Migration[7.0]
  def change
    add_column :saved_scenarios, :private, :boolean, default: false, after: :end_year
  end
end
