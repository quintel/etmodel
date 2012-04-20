class UpdateHouseholdDistrictHeatingImage < ActiveRecord::Migration
  def up
    Slide.find(149).update_attribute :image, 'ico-house-direct-heating.gif'
  end

  def down
  end
end
