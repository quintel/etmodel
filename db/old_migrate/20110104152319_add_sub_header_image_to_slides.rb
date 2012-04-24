class AddSubHeaderImageToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :subheader_image, :string
  end

  def self.down
    remove_column :slides, :subheader_image
  end
end