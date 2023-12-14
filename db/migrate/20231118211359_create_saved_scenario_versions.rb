class CreateSavedScenarioVersions < ActiveRecord::Migration[7.0]
  def up
    # Create new table + indices
    create_table :saved_scenario_versions do |t|
      t.timestamps
      t.belongs_to :saved_scenario
      t.integer :scenario_id, null: false
      t.belongs_to :user
      t.string :message, null: false
    end

    # Index to look up versions by their saved_scenario
    add_index :saved_scenario_versions, :saved_scenario_id, name: 'saved_scenario_versions_saved_scenario_id_idx'
    # Index to look up versions by their user
    add_index :saved_scenario_versions, :user_id, name: 'saved_scenario_versions_user_id_idx'
    # Index to put a unique constraint on the combination of saved_scenario and scenario
    add_index :saved_scenario_versions, [:saved_scenario_id, :scenario_id],
      unique: true, name: 'saved_scenario_users_saved_scenario_id_scenario_id_idx'

    # Create SavedScenarioVersions for all SavedScenarios in batches
    SavedScenario.find_each do |saved_scenario|
      saved_scenario_owner = saved_scenario.saved_scenario_users.where(role_id: User::ROLES.key(:scenario_owner)).first

      next unless saved_scenario_owner.present?

      # First add al historic scenarios as SavedScenarioVersions
      saved_scenario_versions = saved_scenario.scenario_id_history.map do |scenario_id|
        {
          saved_scenario_id: saved_scenario.id,
          scenario_id: scenario_id,
          user_id: saved_scenario_owner.user_id,
          message: "Updated the scenario."
        }
      end

      # Then add the current scenario as the latest version
      saved_scenario_versions << {
        saved_scenario_id: saved_scenario.id,
        scenario_id: saved_scenario.scenario_id,
        user_id: saved_scenario_owner.user_id,
        message: "Updated the scenario."
      }

      # Persist the SavedScenarioVersions in one go
      SavedScenarioVersion.insert_all(saved_scenario_versions)

      # Lastly set the current SavedScenarioVersion for this SavedScenario
      saved_scenario.update(
        saved_scenario_version_id:
          saved_scenario.saved_scenario_versions.find_by(scenario_id: saved_scenario.scenario_id).id
      )
    end
  end

  def down
    remove_index :saved_scenario_versions, name: 'saved_scenario_versions_saved_scenario_id_idx'
    remove_index :saved_scenario_versions, name: 'saved_scenario_versions_user_id_idx'
    remove_index :saved_scenario_versions, name: 'saved_scenario_users_saved_scenario_id_scenario_id_idx'

    drop_table :saved_scenario_versions
  end
end
