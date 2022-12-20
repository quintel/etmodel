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
  end

  context 'when a user' do
    subject(:ability) { described_class.new(user) }

    let(:user) { create(:user) }

    it 'may view a public saved scenario' do
      expect(ability).to be_able_to(:read, create(:saved_scenario, user:, private: false))
    end

    it 'may view a public saved scenario belong to someone else' do
      expect(ability).to be_able_to(:read, create(:saved_scenario, user: create(:user), private: false))
    end

    it 'may view their own private saved scenarios' do
      expect(ability).to be_able_to(:read, create(:saved_scenario, user:, private: true))
    end

    it 'may not view private saved scenarios belonging to someone else' do
      expect(ability).not_to be_able_to(:read, create(:saved_scenario, user: create(:user), private: true))
    end

    it 'may create a saved scenario' do
      expect(ability).to be_able_to(:create, SavedScenario)
    end

    it 'may update their own saved scenario' do
      expect(ability).to be_able_to(:update, create(:saved_scenario, user:))
    end

    it 'may not update someone elses saved scenario' do
      expect(ability).not_to be_able_to(:update, create(:saved_scenario, user: create(:user)))
    end

    it 'may destroy their own saved scenario' do
      expect(ability).to be_able_to(:destroy, create(:saved_scenario, user:))
    end

    it 'may not destroy someone elses saved scenario' do
      expect(ability).not_to be_able_to(:destroy, create(:saved_scenario, user: create(:user)))
    end
  end
end
