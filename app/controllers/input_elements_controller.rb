# frozen_string_literal: true

# A controller for the retrieving the input_element resource.
class InputElementsController < ApplicationController
  # Responds with a JSON array containing the name and key of each slide which
  # has at least one slider, and belongs to a sidebar item and tab. The slide
  # information also includes a brief summary of each slider.
  #
  # GET /input_elements/by_slide
  def by_slide
    # Include only sliders which are visible in the UI.
    slides = Slide.ordered.select(&:visible_with_inputs?)
    render(json: SlidePresenter.collection(slides))
  end
end
