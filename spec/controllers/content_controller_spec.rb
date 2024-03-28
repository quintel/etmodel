# frozen_string_literal: true

describe ContentController, vcr: true do
  render_views

  describe 'whats new' do
    it 'renders an h1' do
      # Assert markdown rendering works
      get :whats_new
      expect(response.body).to have_css('.whats_new h1', text: /april/i)
    end
  end
end
