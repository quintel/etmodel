class SearchController < ApplicationController

  def index
    @query = params[:q]

    # the rescue clauses are used to hide Riddle::ConnectionError
    # exceptions from the user
    @pages          = PageTitle.search(@query).compact rescue []
    @input_elements = InputElement.search(@query).compact rescue []
    @slides         = Slide.search(@query).compact rescue []
  end
end
