# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  context 'when a guest' do
    subject(:ability) { described_class.new(nil) }

    it 'may view a public saved scenario' do
      expect(ability).to be_able_to(:read, create(:saved_scenario, private: false))
    end

    it 'may not view a private saved scenario' do
      expect(ability).not_to be_able_to(:read, create(:saved_scenario, private: true))
    end

    it 'may not create a saved scenario' do
      expect(ability).not_to be_able_to(:create, SavedScenario)
    end

    it 'may not update a saved scenario' do
      expect(ability).not_to be_able_to(:update, create(:saved_scenario))
    end

    it 'may not destroy a saved scenario' do
      expect(ability).not_to be_able_to(:destroy, create(:saved_scenario))
    end

    it 'may not destroy a multi year chart' do
      expect(ability).not_to be_able_to(:destroy, create(:saved_scenario))
    end
  end

  context 'when a user' do
    subject(:ability) { described_class.new(user) }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:public_scenario) { create(:saved_scenario, user: user, private: false) }
    let!(:private_scenario) { create(:saved_scenario, user: user, private: true) }
    let!(:other_public_scenario) { create(:saved_scenario, user: other_user, private: false) }
    let!(:other_private_scenario) { create(:saved_scenario, user: other_user, private: true) }

    it 'may view a public saved scenario' do
      expect(ability).to be_able_to(:read, public_scenario)
    end

    it 'may view a public saved scenario belong to someone else' do
      expect(ability).to be_able_to(:read, other_public_scenario)
    end

    it 'may view their own private saved scenarios' do
      expect(ability).to be_able_to(:read, private_scenario)
    end

    it 'may not view private saved scenarios belonging to someone else' do
      expect(ability).not_to be_able_to(:read, other_private_scenario)
    end

    it 'may create a saved scenario' do
      expect(ability).to be_able_to(:create, SavedScenario)
    end

    it 'may update their own saved scenario' do
      expect(ability).to be_able_to(:update, private_scenario)
    end

    it 'may not update someone elses saved scenario' do
      expect(ability).not_to be_able_to(:update, other_private_scenario)
    end

    it 'may destroy their own saved scenario' do
      expect(ability).to be_able_to(:destroy, private_scenario)
    end

    it 'may not destroy someone elses saved scenario' do
      expect(ability).not_to be_able_to(:destroy, other_private_scenario)
    end

    it 'may destroy their own multi year chart' do
      expect(ability).to be_able_to(:destroy, create(:multi_year_chart, user:))
    end

    it 'may not destroy someone elses multi year chart' do
      expect(ability).not_to be_able_to(:destroy, create(:multi_year_chart, user: create(:user)))
    end
  end
end
