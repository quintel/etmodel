class CreateEsdlSuiteId < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up { change_column(:users, :id, :bigint, auto_increment: true) }
      dir.down { change_column(:users, :id, :int) }
    end

    create_table :esdl_suite_ids do |t|
      t.belongs_to  :user, null: false, foreign_key: true, index: { unique: true }

      t.string      :access_token,      limit: 2048
      t.string      :refresh_token,     limit: 2048

      t.datetime    :expires_at
    end
  end
end
