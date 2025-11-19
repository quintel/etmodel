# frozen_string_literal: true

describe ContentController, vcr: true do
  render_views

  describe 'releases' do
    it 'redirects to the documentation site' do
      get :releases
      expect(response).to redirect_to(ApplicationController.helpers.releases_external_url)
    end
  end
end
