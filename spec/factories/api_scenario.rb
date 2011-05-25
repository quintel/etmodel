Factory.define :api_scenario, :class => Api::Scenario do |api_scenario|
  api_scenario.country {"de"}
  api_scenario.end_year { 2050 }
end
