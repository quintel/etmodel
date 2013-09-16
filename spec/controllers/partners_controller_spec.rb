require 'spec_helper'

describe PartnersController do
  render_views
  describe "#index" do
    it "should show the partner list" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end
