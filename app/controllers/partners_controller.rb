class PartnersController < ApplicationController
  def show
    country = Current.setting.area_code rescue nil
    @partner = Partner.find_by_slug_localized(params[:id], country)
    raise ActiveRecord::RecordNotFound if @partner.nil?
  end

  def index
    @info = Text.where(key: :partner_info).first
    # regions should use country partners
    country = Current.setting.country
    @all_partners = Partner.country(country).unique.sort_by{Kernel.rand}
    @partner_types = ['general']
    @partner_types << 'knowledge' if @all_partners.map(&:partner_type).include?('knowledge')
    @partner_types << 'education' if @all_partners.map(&:partner_type).include?('education')
    @active_partner_type   = params[:partner_type]
    @active_partner_type ||= 'general'

    @partners = @all_partners.select{|p|p.partner_type == @active_partner_type}


  end
end
