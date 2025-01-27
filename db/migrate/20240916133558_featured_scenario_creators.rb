class FeaturedScenarioCreators < ActiveRecord::Migration[7.1]
  def up
    add_column :featured_scenarios, :featured_owner, :string
    # FeaturedScenario.reset_column_information
    # FeaturedScenario.all.each do |fs|
    #   ss = fs.saved_scenario
    #   if ss.owners.any?
    #     fs.update_column(:featured_owner, ss.owners.first.user.name)
    #   else
    #     fs.update_column(:featured_owner, "Unknown owner")
    #   end
    # end
  end

  def down
    remove_column :featured_scenarios, :featured_owner
  end

end
