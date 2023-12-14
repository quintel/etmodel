require 'rails_helper'

describe SavedScenarioVersion do
  it { is_expected.to belong_to(:saved_scenario) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:scenario_id) }
  it { is_expected.to validate_presence_of(:message) }
end

