class SearchController < ApplicationController
  def index
    @query = params[:q]
    @sidebar_items  = SidebarItem.search{|s| s.fulltext @query}.results
    @input_elements = InputElement.search{|s| s.fulltext @query}.results
    @slides         = Slide.search{|s| s.fulltext @query}.results
  end
end
