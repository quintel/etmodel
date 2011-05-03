class AddLightAttrToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :market_share_daylight_control, :float
    add_column :areas, :market_share_motion_detection, :float
  end

  def self.down
    remove_column :areas, :market_share_daylight_control
    remove_column :areas, :market_share_motion_detection
  end
end
