class SearchController < ApplicationController
  def index
    @query = params[:q]

    # @sidebar_items  = SidebarItem.search{|s| s.fulltext @query}.results
    # @input_elements = InputElement.search{|s| s.fulltext @query}.results.
      # reject{|s| s.slide.nil?}
    # @slides = Slide.search{|s| s.fulltext @query}.results.
      # reject(&:removed_from_interface?)

    @sidebar_items = @input_elements = @slides = []
  end
end
