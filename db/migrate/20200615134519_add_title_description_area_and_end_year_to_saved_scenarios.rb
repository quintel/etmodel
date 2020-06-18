class AddTitleDescriptionAreaAndEndYearToSavedScenarios < ActiveRecord::Migration[5.2]
  def up
    add_column :saved_scenarios, :title, :string, null: false, after: :scenario_id_history
    add_column :saved_scenarios, :description, :text, after: :title
    add_column :saved_scenarios, :area_code, :string, null: false, after: :description
    add_column :saved_scenarios, :end_year, :integer, null: false, after: :area_code

    # Get current titles and descriptions from ETEngine
    saved_scenarios = SavedScenario.all
    total = saved_scenarios.size
    done = 0
    failed = 0
    puts "Updating #{total} saved scenarios by extracting details from ETEngine"

    # Load batches of 100 at a time
    saved_scenarios.in_groups_of(100, false) do |chunked_saved_scenarios|
      SavedScenario.batch_load(
        chunked_saved_scenarios,
        query: { detailed: true }
      )

      chunked_saved_scenarios.each do |saved_scenario|
        scenario = saved_scenario.scenario(detailed: true)

        # Older scenarios may not be accessible anymore
        if scenario
          saved_scenario.update_columns(
            title: scenario.title,
            description: scenario.description,
            area_code: scenario.area_code,
            end_year: scenario.end_year
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
    remove_column :saved_scenarios, :area_code
    remove_column :saved_scenarios, :end_year
  end
end
