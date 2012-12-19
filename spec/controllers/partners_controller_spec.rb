require 'spec_helper'

describe PartnersController do
  render_views
  let!(:partner)   { FactoryGirl.create :partner, :name => 'foobar', :country => 'nl' }

  describe "#index" do
    it "should show the partner list" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "#show" do
    it "should show the partner detail page" do
      get :show, :id => 'foobar'
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
