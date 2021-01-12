class CreateEsdlSuiteId < ActiveRecord::Migration[5.2]
  def change
    create_table :esdl_suite_ids do |t|
      t.belongs_to  :user, null: false

      t.string      :access_token,      limit: 2048
      t.string      :refresh_token,     limit: 2048

      t.datetime    :expires_at
    end
  end
end
