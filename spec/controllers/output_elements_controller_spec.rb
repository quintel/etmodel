require 'spec_helper'

describe OutputElementsController, vcr: true do
  render_views

  describe "#index" do
    it "should render the page correctly" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end
