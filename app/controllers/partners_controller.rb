class PartnersController < ApplicationController
  layout 'pages'

  def show
    @partner = Partner.find_by_slug(params[:id])
    render :file => 'public/404.html', :status => 404 if @partner.nil?
  end

  def index
    @country = Current.setting.country
    @partners = Partner.country(@country).unique.sort_by{Kernel.rand}
  end
end
