class UpdateFceSlidersUpdateType < ActiveRecord::Migration
  def self.up
    execute "UPDATE  `input_elements` SET `update_type` = 'fce' WHERE `update_type` = 'lce';"
  end

  def self.down
  end
end
