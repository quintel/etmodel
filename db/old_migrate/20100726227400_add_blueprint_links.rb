class Link < ActiveRecord::Base
end

class AddBlueprintLinks < ActiveRecord::Migration
  def self.up
    # this column is references the corresponding blueprint_link
    add_column :links, :blueprint_link_id, :integer

    Link.find_each do |link|
      bpl = BlueprintLink.create!(:blueprint_id => link.graph_id,
       :parent_id => link.parent_id,
       :child_id => link.converter_id,
       :blueprint_carrier_id => link.carrier_id,
       :link_type => link.link_type)

      link.blueprint_link_id = bpl.id
      link.save!
    end
  end

  def self.down
    remove_column :links, :blueprint_link_id
    BlueprintSlot.destroy_all
  end
end
