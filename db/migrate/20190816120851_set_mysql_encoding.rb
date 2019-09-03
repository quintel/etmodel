class SetMysqlEncoding < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.adapter_name.downcase =~ /^mysql/
      return
    end

    ActiveRecord::Base.transaction do
      # Indexed VARCHAR columns must have length 191 or less when using MySQL
      # 5.6 or older (*cough* Semaphore). https://stackoverflow.com/a/31474509
      change_column :ar_internal_metadata, :key, :string, limit: 191
      change_column :area_dependencies, :dependable_type, :string, limit: 191
      change_column :constraints, :key, :string, limit: 191
      change_column :descriptions, :describable_type, :string, limit: 191
      change_column :input_elements, :key, :string, limit: 191
      change_column :input_elements, :command_type, :string, limit: 191
      change_column :output_elements, :key, :string, limit: 191
      change_column :schema_migrations, :version, :string, limit: 191
      change_column :sessions, :session_id, :string, limit: 191
      change_column :sidebar_items, :key, :string, limit: 191
      change_column :slides, :key, :string, limit: 191
      change_column :tabs, :key, :string, limit: 191
      change_column :texts, :key, :string, limit: 191
      change_column :users, :email, :string, limit: 191

      say_with_time "Updating database" do
        ActiveRecord::Base.connection.execute(<<~SQL)
          ALTER DATABASE #{ActiveRecord::Base.connection.current_database}
          CHARACTER SET = utf8mb4
          COLLATE = utf8mb4_unicode_ci
        SQL
      end

      ActiveRecord::Base.connection.tables.each do |table|
        say_with_time "Updating #{table}" do
          ActiveRecord::Base.connection.execute(<<~SQL)
            ALTER TABLE #{table}
            CONVERT TO CHARACTER SET utf8mb4
            COLLATE utf8mb4_unicode_ci
          SQL
        end
      end

      # Updating to mb4 seems to switch TEXT columns to MEDIUMTEXT. I guess this
      # makes sense where they may be long text descriptions, but in most cases
      # it isn't needed...
      text_length = 64.kilobytes - 1

      change_column :area_dependencies, :description, :text, limit: text_length
      change_column :descriptions, :short_content_en, :text, limit: text_length
      change_column :descriptions, :short_content_nl, :text, limit: text_length
      change_column :input_elements, :comments, :text, limit: text_length
      change_column :saved_scenarios, :settings, :text, limit: text_length
      change_column :sidebar_items, :percentage_bar_query, :text, limit: text_length
      change_column :texts, :short_content_en, :text, limit: text_length
      change_column :texts, :short_content_nl, :text, limit: text_length
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name.downcase =~ /^mysql/
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
