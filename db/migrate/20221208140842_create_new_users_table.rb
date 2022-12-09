class CreateNewUsersTable < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :esdl_suite_ids, :users
    remove_foreign_key :surveys, :users

    rename_table :users, :users_old

    change_column :saved_scenarios, :user_id, :bigint

    create_table 'users', id: :bigint, default: nil do |t|
      t.string 'name', null: false
      t.timestamps
    end

    execute <<~SQL
      INSERT INTO users (id, name, created_at, updated_at)
      SELECT id, name, created_at, updated_at FROM users_old
    SQL

    remove_orphans(EsdlSuiteId)
    remove_orphans(MultiYearChart)
    remove_orphans(SavedScenario)
    remove_orphans(Survey)

    add_foreign_key :esdl_suite_ids, :users
    add_foreign_key :multi_year_charts, :users
    add_foreign_key :saved_scenarios, :users
    add_foreign_key :surveys, :users
  end

  def down
    drop_foreign_key :esdl_suite_ids, :users, on_delete: :cascade
    drop_foreign_key :multi_year_charts, :users, on_delete: :cascade
    drop_foreign_key :saved_scenarios, :users, on_deleta: :cascade
    drop_foreign_key :surveys, :users, on_delete: :cascade

    drop_table :users

    rename_table :users_old, :users

    change_column :saved_scenarios, :integer, :bigint

    add_foreign_key :esdl_suite_ids, :users
    add_foreign_key :surveys, :users
  end

  private

  def remove_orphans(klass)
    say_with_time "Removing orphans: #{klass.name}" do
      removed = 0

      klass.find_each do |record|
        next if User.exists?(record.user_id)

        removed += 1
        record.destroy
      end

      say "Removed: #{removed}"
    end
  end
end
