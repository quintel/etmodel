class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.references :attachable, :polymorphic => true
      t.string :title
      t.string :file_file_name
      t.string :file_content_type
      t.string :file_file_size
      t.string :file_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
