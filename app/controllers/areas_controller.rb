# frozen_string_literal: true

class AreasController < ActionController::API
  def index
    @areas = Api::Area.all
    render json: Api::Area.all.map { |area| serialize_area(area) }
  end

  def show
    @area = Api::Area.find_by_country_memoized(params[:id])

    if @area
      render json: serialize_area(@area)
    else
      render json: { errors: ['Area not found'] }, status: :not_found
    end
  end

  private

  def serialize_area(area)
    {
      id: area.area,
      name: {
        en: I18n.t(area.area, scope: 'areas', default: area.area, locale: :en),
        nl: I18n.t(area.area, scope: 'areas', default: area.area, locale: :nl)
      },
      icon: serialize_flag(area)
    }
  end

  def serialize_flag(area)
    {
      href: helpers.asset_path("flags-24/#{area.country_area.area.downcase}.png"),
      height: 17,
      width: 23
    }
  rescue Sprockets::Rails::Helper::AssetNotFound
    nil
  end
end
