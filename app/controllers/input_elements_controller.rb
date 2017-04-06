# frozen_string_literal: true

class InputElementsController < ApplicationController
  # Responds with a JSON array containing the name and key of each slide which
  # has at least one slider, and belongs to a sidebar item and tab. The slide
  # information also includes a brief summary of each slider.
  #
  # GET /input_elements/by_slide
  def by_slide
    slides = Slide.ordered.includes({ sidebar_item: :tab }, :sliders)

    # Include only sliders which are visible in the UI.
    slides = slides.select do |slide|
      slide.sidebar_item.try(:tab) && slide.sliders.any?
    end

    render(json: SlidePresenter.collection(slides))
  end
end
