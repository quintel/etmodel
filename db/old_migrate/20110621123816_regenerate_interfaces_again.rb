class RegenerateInterfacesAgain < ActiveRecord::Migration
  def self.up
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
  end
end
