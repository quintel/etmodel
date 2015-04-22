def ete_scenario_mock
  mock = double("api_scenario")
  mock.stub(:id){"123"}
  mock.stub(:title){"title"}
  mock.stub(:end_year){"2050"}
  mock.stub(:area_code){"nl"}
  mock.stub(:parsed_created_at){ Time.now }
  mock.stub(:created_at){ Time.now }
  mock.stub(:all_inputs){ {} }
  mock
end
