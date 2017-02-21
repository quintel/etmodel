def ete_scenario_mock
  mock = double("api_scenario")
  allow(mock).to receive(:id){"123"}
  allow(mock).to receive(:title){"title"}
  allow(mock).to receive(:end_year){"2050"}
  allow(mock).to receive(:area_code){"nl"}
  allow(mock).to receive(:parsed_created_at){ Time.now }
  allow(mock).to receive(:created_at){ Time.now }
  allow(mock).to receive(:all_inputs){ {} }
  mock
end
