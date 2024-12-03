# frozen_string_literal: true

require 'rails_helper'

describe FeaturedScenariosController do
  pending 'NEEDS TO BE CHANGED'
  render_views

  # let(:saved_scenario) { FactoryBot.create(:saved_scenario) }

  pending 'when not signed in' do
    it 'renders 404' do
      get(:show, params: { saved_scenario_id: saved_scenario.id })
      expect(response.status).to eq(404)
    end
  end

  pending 'when signed in as a user' do
    before do
      sign_in(FactoryBot.create(:user))
    end

    it 'renders 404' do
      get(:show, params: { saved_scenario_id: saved_scenario.id })
      expect(response.status).to eq(404)
    end
  end

  pending 'when signed in as an admin' do
    before do
      sign_in(FactoryBot.create(:admin))
    end

    it 'shows the featured scenario form' do
      get(:show, params: { saved_scenario_id: saved_scenario.id })
      expect(response.status).to eq(200)
    end

    pending 'when creating an invalid featured scenario' do
      let(:request) do
        get(
          :create,
          params: {
            saved_scenario_id: saved_scenario.id,
            featured_scenario: FactoryBot.attributes_for(:featured_scenario).except(:title_en)
          }
        )
      end

      let(:featured_scenario) { saved_scenario.featured_scenario }

      it 'does not create the featured scenario' do
        expect { request }.not_to change(FeaturedScenario, :count)
      end

      it 'returns an error' do
        request
        expect(response.status).to eq(422)
      end

      it 'renders the form' do
        request
        expect(response).to render_template(:edit)
      end
    end

    pending 'when creating a new, valid featured scenario' do
      let(:request) do
        get(
          :create,
          params: {
            saved_scenario_id: saved_scenario.id,
            featured_scenario: FactoryBot.attributes_for(
              :featured_scenario,
              title_en: 'English title',
              title_nl: 'Dutch title',
              description_en: 'English description',
              description_nl: 'Dutch description'
            )
          }
        )
      end

      let(:featured_scenario) { saved_scenario.featured_scenario }

      it 'allows creating a featured scenario' do
        expect { request }.to change(FeaturedScenario, :count).by(1)
      end

      it 'redirects to the scenario page' do
        expect(request).to redirect_to(saved_scenario_url(featured_scenario.saved_scenario))
      end

      it 'sets the saved scenario ID of the featured scenario' do
        request
        expect(featured_scenario.saved_scenario_id).to eq(saved_scenario.id)
      end

      it 'sets the NL title' do
        request
        expect(featured_scenario.title_nl).to eq('Dutch title')
      end

      it 'sets the EN title' do
        request
        expect(featured_scenario.title_en).to eq('English title')
      end

      it 'sets the NL description' do
        request
        expect(featured_scenario.description_nl).to eq('Dutch description')
      end

      it 'sets the EN description' do
        request
        expect(featured_scenario.description_en).to eq('English description')
      end
    end

    pending 'when updating a featured scenario with valid attributes' do
      let(:featured_scenario) { FactoryBot.create(:featured_scenario) }
      let(:request) do
        get(
          :update,
          params: {
            saved_scenario_id: featured_scenario.saved_scenario_id,
            featured_scenario: { title_en: 'New English title' }
          }
        )
      end

      it 'redirects to the scenario page' do
        expect(request).to redirect_to(saved_scenario_url(featured_scenario.saved_scenario))
      end

      it 'sets the new attributes' do
        request
        expect(featured_scenario.reload.title_en).to eq('New English title')
      end
    end

    pending 'when updating a featured scenario with invalid attributes' do
      let(:featured_scenario) { FactoryBot.create(:featured_scenario) }
      let(:request) do
        get(
          :update,
          params: {
            saved_scenario_id: featured_scenario.saved_scenario_id,
            featured_scenario: { title_en: '' }
          }
        )
      end

      it 'does not create the featured scenario' do
        expect { request }.not_to(change { featured_scenario.reload.title_en })
      end

      it 'returns an error' do
        request
        expect(response.status).to eq(422)
      end

      it 'renders the form' do
        request
        expect(response).to render_template(:edit)
      end
    end

    pending 'when removing a featured scenario' do
      it 'removes the scenario' do
        FactoryBot.create(:featured_scenario, saved_scenario: saved_scenario)

        expect { get(:destroy, params: { saved_scenario_id: saved_scenario.id }) }
          .to change(FeaturedScenario, :count).by(-1)
      end
    end
  end
end
