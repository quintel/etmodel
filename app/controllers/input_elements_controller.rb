# frozen_string_literal: true

# A controller for the retrieving the input_element resource.
class InputElementsController < ApplicationController
  before_action :myc_content_security_policy, only: :by_slide

  # Responds with a JSON array containing the name and key of each slide which
  # has at least one slider, and belongs to a sidebar item and tab. The slide
  # information also includes a brief summary of each slider.
  #
  # GET /input_elements/by_slide
  def by_slide
    # Include only sliders which are visible in the UI.
    json = Rails.cache.fetch("input_elements/by_slide?locale=#{I18n.locale}") do
      slides = Slide.ordered.select(&:visible_with_inputs?)
      SlidePresenter.collection(slides).to_json
    end

    render(json:)
  end

  private

  # Internal: For requests originating in the "multi-year charts" application, we must loading the
  # input elements from the same domain as the application.
  def myc_content_security_policy
    url = Settings.multi_year_charts_url

    return unless url

    response.set_header('Access-Control-Allow-Origin', url)
    response.set_header('Access-Control-Allow-Methods', 'GET')
    response.set_header('Access-Control-Allow-Headers', 'Accept, Accept-Language, Content-Type')
  end
end
