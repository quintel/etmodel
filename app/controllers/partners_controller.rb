class PartnersController < ApplicationController
  layout 'pages'

  def show
    @partner = Partner.find_by_slug(params[:id])
    render :template => 'public/404.html', :status => 404 if @partner.nil? 
  end

  def index
    @country = Current.scenario.country
    @partners = Partner.country(@country).unique.sort_by{Kernel.rand}
    #if @country = Current.scenario.country
    #  @partners_in_country = Partner.country(@country)
    #end
  end

  def create
    redirect_to :back
  end
end
