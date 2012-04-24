class RemoveLegacyDefaultOutputElementId < ActiveRecord::Migration
  def self.up
    remove_column :slides, :default_output_element_id
    
    # Regenerate interfaces, one more time...
    Interface.destroy_all
    ViewNode::Root.find_each do |r|
      Interface.create!(
        :key       => r.key,
        :enabled   => true,
        :structure => r.tree_to_yml
      )
    end
    
  end

  def self.down
    add_column :slides, :default_output_element_id, :integer
  end
end
