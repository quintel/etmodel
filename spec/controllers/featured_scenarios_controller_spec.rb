# frozen_string_literal: true

require 'rails_helper'

describe FeaturedScenariosController do
  render_views

  let(:saved_scenario) { FactoryBot.create(:saved_scenario) }

  context 'when not signed in' do
    it 'renders 404' do
      get(:new, params: { id: saved_scenario.id })
      expect(response.code).to eq('404')
    end
  end

  context 'when signed in as a user' do
    before do
      login_as(FactoryBot.create(:user))
    end

    it 'renders 404' do
      get(:new, params: { id: saved_scenario.id })
      expect(response.code).to eq('404')
    end
  end

  context 'when signed in as an admin' do
    before do
      login_as(FactoryBot.create(:admin))
    end

    it 'shows the featured scenario form' do
      get(:new, params: { id: saved_scenario.id })
      expect(response.code).to eq('200')
    end

    context 'when creating a new, valid featured scenario' do
      it 'allows creating a featured scenario' do
        expect do
          get(:create, params: {
            id: saved_scenario.id,
            featured_scenario: { group: FeaturedScenario::GROUPS.first }
          })
        end.to change(FeaturedScenario, :count).by(1)
      end
    end

    context 'when removing a featured scenario' do
      it 'removes the scenario' do
        FeaturedScenario.create!(saved_scenario: saved_scenario)

        expect { get(:destroy, params: { id: saved_scenario.id }) }
          .to change(FeaturedScenario, :count).by(-1)
      end
    end
  end
end
