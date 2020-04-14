require 'rails_helper'

describe DescriptionsController do
  render_views

  let(:chart) { OutputElement.all.first }
  let(:description) { chart.description }

  describe "#charts" do
    it "should return the chart description" do
      get :charts, params: { id: chart.key }

      expect(response).to be_successful
      expect(response).to render_template(:show)

      expect(response.body).to_not be_empty
    end
  end
end
