require 'spec_helper'

describe TextsController, type: :controller do
  let!(:text) { FactoryGirl.create :text, :key => 'foobar'}

  describe "#show" do
    it "should show the text detail page" do
      get :show, :id => 'foobar'
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
