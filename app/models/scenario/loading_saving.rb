##
# Loading & Saving Scenarios
#
class Scenario < ActiveRecord::Base

  ##
  # Reset all values that can be changed by a user and influences GQL
  # to the default/empty values.
  #
  # @tested 2010-12-06 seb
  #
  def reset!
    self.user_values = {}
    self.update_statements = {}
    
    self.number_of_households = nil
    self.number_of_existing_households = nil
  end
  alias_method :reset_user_values!, :reset!

  ##
  # Called from current. 
  #
  def load!
    build_update_statements(false)
  end

  ##
  # 
  # @untested 2010-12-06 seb
  #
  def load_scenario(options = {})
    # TODO make a scenario type which is a municipality_preset (2010-12-21 jape)
    build_update_statements(options[:municipality_preset])

    scenario_before = Current.scenario
    if options[:municipality_preset]
      store_region = Current.scenario.region
      Current.scenario = self
      Current.scenario.region = store_region
    else
      Current.scenario = self
    end
    if !options[:municipality_preset]
      # when the user loads a scenario from the start menu, the form contains a complexity selector
      self.complexity ||= scenario_before.complexity 
    end
  end

  ##
  # Stores the current settings into the attributes. For when we want to save
  # the scenario in the db.
  #
  # @untested 2010-12-06 seb
  #
  def copy_scenario_state(scenario)
    self.user_values = scenario.user_values.clone
    self.end_year = scenario.end_year
    self.country = scenario.country ? scenario.country.clone : nil
    self.region = scenario.region ? scenario.region.clone : nil
    self.complexity = scenario.complexity
    self.lce_settings = scenario.lce_settings
  end

end