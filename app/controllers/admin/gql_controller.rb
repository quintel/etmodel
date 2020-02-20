# frozen_string_literal: true

module Admin
  # Lists the items that contain references to gqueries or converters. Useful
  # when renaming or deleting stuff on etsource
  class GqlController < Admin::BaseController
    def search
      @q = params[:q]
      @output_element_series = OutputElementSerie.gquery_contains(@q)
      @constraints = Constraint.gquery_contains(@q)
      @sidebar_items = SidebarItem.gquery_contains(@q)
      @sliders = InputElement.with_related_converter_like(@q)
    end
  end
end
