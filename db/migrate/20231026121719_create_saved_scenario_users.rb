class CreateSavedScenarioUsers < ActiveRecord::Migration[7.0]
  def up
    # Create new table + indices
    create_table :saved_scenario_users do |t|
      t.integer     :user_id, null: false
      t.integer     :saved_scenario_id, null: false
      t.integer     :role_id, null: false
      t.string      :user_email, default: nil
    end

    add_index :saved_scenario_users, [:saved_scenario_id, :user_id], name: 'saved_scenario_users_saved_scenario_id_user_id_idx'
    add_index :saved_scenario_users, :user_email, name: 'saved_scenario_users_user_email_idx'

    # Create SavedScenarioUser relations for currently existing saved scenarios
    SavedScenario.in_batches.each do |saved_scenario_batch|
      saved_scenario_users = saved_scenario_batch.pluck(:id, :user_id)
      saved_scenario_users.map! do |su|
        {
          saved_scenario_id: su[0],
          user_id: su[1],
          role_id: User::ROLES.key(:scenario_owner),
          user_email: nil
        }
      end

      SavedScenarioUser.insert_all(saved_scenario_users)
    end
  end

  def down
    remove_index :saved_scenario_users, name: 'saved_scenario_users_saved_scenario_id_user_id_idx'
    remove_index :saved_scenario_users, name: 'saved_scenario_users_user_email_idx'
    drop_table :saved_scenario_users
  end
end
