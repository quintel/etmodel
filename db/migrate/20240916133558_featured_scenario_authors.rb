class FeaturedScenarioAuthors < ActiveRecord::Migration[7.1]
  def up
    add_column :featured_scenarios, :author, :string
    FeaturedScenario.all.each do |fs|
      ss = fs.saved_scenario
      if ss.owners.any?
        fs.update(author: ss.owners.first.user.name)
      else
        fs.update(author: "Unknown owner")
      end
    end
  end

  def down
    remove_column :featured_scenarios, :author
  end

end
