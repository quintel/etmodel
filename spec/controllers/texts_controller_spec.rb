require 'rails_helper'

describe TextsController do
  let!(:text) { FactoryBot.create :text, key: 'foobar'}

  describe "#show" do
    it "should show the text detail page" do
      get :show, params: { id: 'foobar' }
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
