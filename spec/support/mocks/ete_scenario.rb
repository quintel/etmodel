def ete_scenario_mock
  mock = double("api_scenario")

  allow(mock).to receive(:id) { "123" }
  allow(mock).to receive(:title) { "title" }
  allow(mock).to receive(:description) { 'description' }
  allow(mock).to receive(:end_year) { "2050" }
  allow(mock).to receive(:area_code) { "nl" }
  allow(mock).to receive(:parsed_created_at) { Time.now }
  allow(mock).to receive(:loadable?) { true }
  allow(mock).to receive(:created_at) { Time.now }
  allow(mock).to receive(:all_inputs) { {} }
  allow(mock).to receive(:days_old) { 1 }
  allow(mock).to receive(:errors) { [] }
  allow(mock).to receive(:use_fce) { nil }
  allow(mock).to receive(:scaling) { nil }

  mock
end
