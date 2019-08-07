class Admin::GqlController < Admin::BaseController
  # Lists the items that contain references to gqueries or converters. Useful
  # when renaming or deleting stuff on etsource
  def search
    @q = params[:q]
    @output_element_series = OutputElementSerie.gquery_contains(@q)
    @constraints = Constraint.gquery_contains(@q)
    @sidebar_items = SidebarItem.gquery_contains(@q)
    @sliders = InputElement.where(["related_converter LIKE ?", "%#{@q}%"])
  end
end
