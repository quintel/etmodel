module Admin
class AreasController < BaseController
  before_filter :deprecated_admin_area_notice

  def index
    @areas = Api::Area.all
  end

  def show
    @area = Api::Area.find(params[:id])
  end
end
end