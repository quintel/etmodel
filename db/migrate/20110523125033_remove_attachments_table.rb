class RemoveAttachmentsTable < ActiveRecord::Migration
  def self.up
    drop_table :attachments
  end

  def self.down
    create_table "attachments", :force => true do |t|
      t.integer  "attachable_id"
      t.string   "attachable_type"
      t.string   "title"
      t.string   "file_file_name"
      t.string   "file_content_type"
      t.string   "file_file_size"
      t.string   "file_updated_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
