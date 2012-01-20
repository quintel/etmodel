class PartnersController < ApplicationController
  layout 'pages'

  def show
    @partner = Partner.find_by_slug(params[:id])
    render :file => 'public/404.html', :status => 404 if @partner.nil?
  end

  def index
    @country = Current.setting.country
    @all_partners = Partner.country(@country).unique.sort_by{Kernel.rand}
    @partner_types = ['general']
    @partner_types << 'knowledge' if @all_partners.map(&:partner_type).include?('knowledge')
    @partner_types << 'education' if @all_partners.map(&:partner_type).include?('education')
    @active_partner_type = params[:partner_type] || 'general'
    @partners = @all_partners.select{|p|p.partner_type == @active_partner_type}
  end
end
