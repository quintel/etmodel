require 'spec_helper'

describe DescriptionsController, type: :controller do
  let!(:chart)   { FactoryGirl.create :output_element_with_description}
  let!(:description)   { chart.description}

  describe "#show" do
    it "should show the description template" do
      get :show, :id => description.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end

  describe "#charts" do
    it "should return the chart description" do
      get :charts, :id => chart.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
