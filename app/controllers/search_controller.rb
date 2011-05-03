class SearchController < ApplicationController
  layout 'etm'

  def index
    @query = params[:q]
    #@results = ThinkingSphinx.search @query, :classes => [InputElement, Slide, PageTitle]

    @pages = PageTitle.search(@query).compact
    @input_elements = InputElement.search(@query).compact
    @slides = Slide.search(@query).compact
  end

end
