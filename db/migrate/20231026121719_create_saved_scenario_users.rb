class CreateSavedScenarioUsers < ActiveRecord::Migration[7.0]
  def up
    # Create new table + indices
    create_table :saved_scenario_users do |t|
      t.integer :saved_scenario_id, null: false
      t.integer :role_id, null: false
      t.integer :user_id, default: nil
      t.string  :user_email, default: nil
    end

    # Index to look up what role a user has on a given scenario
    add_index :saved_scenario_users, [:saved_scenario_id, :user_id, :role_id], name: 'saved_scenario_users_saved_scenario_id_user_id_role_id_idx'
    # Index to look up user emails for when a new user registers
    add_index :saved_scenario_users, :user_email, name: 'saved_scenario_users_user_email_idx'
    # Indeces to put unique constraints a scenario for a given user_id/email to prevent duplicate records and roles
    add_index :saved_scenario_users, [:saved_scenario_id, :user_id], unique: true, name: 'saved_scenario_users_saved_scenario_id_user_id_idx'
    add_index :saved_scenario_users, [:saved_scenario_id, :user_email], unique: true, name: 'saved_scenario_users_saved_scenario_id_user_email_idx'

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
    remove_index :saved_scenario_users, name: 'saved_scenario_users_saved_scenario_id_user_id_role_id_idx'
    remove_index :saved_scenario_users, name: 'saved_scenario_users_user_email_idx'
    remove_index :saved_scenario_users, name: 'saved_scenario_users_saved_scenario_id_user_id_idx'
    remove_index :saved_scenario_users, name: 'saved_scenario_users_saved_scenario_id_user_email_idx'
    drop_table :saved_scenario_users
  end
end
