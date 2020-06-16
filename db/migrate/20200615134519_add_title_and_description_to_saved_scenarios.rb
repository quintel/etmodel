class AddTitleAndDescriptionToSavedScenarios < ActiveRecord::Migration[5.2]
  def up
    add_column :saved_scenarios, :title, :string
    add_column :saved_scenarios, :description, :text

    # Get current titles and descriptions from ETEngine
    saved_scenarios = SavedScenario.all
    total = saved_scenarios.size
    done = 0
    failed = 0
    puts "Updating #{total} saved scenarios"

    # ETEngine only allows batches of maximum length 2048
    saved_scenarios.in_groups_of(2048, false) do |chunked_saved_scenarios|
      SavedScenario.batch_load(
        chunked_saved_scenarios,
        params: { detailed: true }
      )

      chunked_saved_scenarios.each do |saved_scenario|
        scenario = saved_scenario.scenario(detailed: true)

        # Older scenarios may not be accessible anymore
        if scenario
          saved_scenario.update_columns(
            title: scenario.title,
            description: scenario.description
          )
        else
          failed += 1
        end

        done += 1
        if done % 500 == 0
          puts "#{done}/#{total} saved scenarios done, with #{failed} failures"
        end
      end
    end
  end

  def down
    remove_column :saved_scenarios, :title
    remove_column :saved_scenarios, :description
  end
end
