# frozen_string_literal: true

# rubocop:disable RSpec/VerifiedDoubles
def ete_scenario_mock
  mock = double('api_scenario')

  allow(mock).to receive(:id).and_return('123')
  allow(mock).to receive(:title).and_return('title')
  allow(mock).to receive(:description).and_return('description')
  allow(mock).to receive(:end_year).and_return('2050')
  allow(mock).to receive(:area_code).and_return('nl')
  allow(mock).to receive(:created_at) { Time.now.utc }
  allow(mock).to receive(:updated_at) { Time.now.utc }
  allow(mock).to receive(:loadable?).and_return(true)
  allow(mock).to receive(:coupled?).and_return(false)
  allow(mock).to receive(:coupling).and_return(false)
  allow(mock).to receive(:created_at) { Time.now.utc }
  allow(mock).to receive(:all_inputs).and_return({})
  allow(mock).to receive(:days_old).and_return(1)
  allow(mock).to receive(:errors).and_return([])
  allow(mock).to receive(:scaling).and_return(nil)
  allow(mock).to receive(:keep_compatible?).and_return(false)
  allow(mock).to receive(:esdl_exportable).and_return(false)
  allow(mock).to receive(:user_values)  do
    double('user_values', attributes: { foo: :bar })
  end

  mock
end
# rubocop:enable RSpec/VerifiedDoubles
