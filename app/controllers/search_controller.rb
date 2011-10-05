class SearchController < ApplicationController
  # Are we sure we want to use the etm layout? Maybe we should only if the
  # user has already started working on a scenario - PZ Mon 4 Jul 2011 10:45:00 CEST
  layout 'pages'

  include ApplicationController::HasDashboard
  
  def index
    @query = params[:q]

    @pages          = PageTitle.search(@query).compact
    @input_elements = InputElement.search(@query).compact
    @slides         = Slide.search(@query).compact
  end
end
