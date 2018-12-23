require 'rails_helper'

describe DescriptionsController do
  render_views

  let!(:chart)   { FactoryBot.create :output_element_with_description}
  let!(:description)   { chart.description}

  describe "#show" do
    it "should show the description template" do
      get :show, params: { id: description.id }

      expect(response).to be_successful
      expect(response).to render_template(:show)

      expect(response.body).to_not be_empty
    end

    it 'renders nothing if no description exists' do
      get :show, params: { id: -1 }

      expect(response).to be_successful
      expect(response.body).to be_empty
    end
  end

  describe "#charts" do
    it "should return the chart description" do
      get :charts, params: { id: chart.id }

      expect(response).to be_successful
      expect(response).to render_template(:show)

      expect(response.body).to_not be_empty
    end

    it 'renders nothing if the chart has no description' do
      chart.description.destroy

      get :charts, params: { id: chart.id }
      expect(response).to be_successful

      expect(response.body).to be_empty
    end
  end
end
