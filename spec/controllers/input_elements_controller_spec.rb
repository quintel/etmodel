# frozen_string_literal: true

require 'rails_helper'

describe InputElementsController do
  render_views

  describe 'by_slide' do
    it 'is successful' do
      get(:by_slide)
      expect(response).to be_successful
    end

    it 'contains an element per visible slide' do
      get(:by_slide)

      # Additional tests of the response are in the SlidePreseter spec.
      expect(JSON.parse(response.body).length)
        .to eq(Slide.all.select(&:visible_with_inputs?).length)
    end

    it 'caches the response per locale with an expiry' do
      expect(Rails.cache).to receive(:fetch)
        .with('input_elements/by_slide?locale=en', expires_in: 1.day)
        .and_call_original

      get(:by_slide)
    end
  end
end
