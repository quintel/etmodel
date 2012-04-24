class CreateGeneralUserNotifications < ActiveRecord::Migration
  def self.up
    create_table :general_user_notifications do |t|
      t.string :key
      t.string :notification_nl
      t.string :notification_en
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :general_user_notifications
  end
end
