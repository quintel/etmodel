class PartnersController < ApplicationController
  def show
    unless @partner = Partner.find(params[:id])
      raise ActiveRecord::RecordNotFound
    end
  end

  def index
    @info = Text.where(key: :partner_info).first
    @all_partners = Partner.all.shuffle
    @partner_types = ['general']
    @partner_types << 'knowledge' if @all_partners.map(&:kind).include?('knowledge')
    @partner_types << 'education' if @all_partners.map(&:kind).include?('education')
    @active_partner_type   = params[:partner_type]
    @active_partner_type ||= 'general'

    @partners = @all_partners.select{|p|p.kind == @active_partner_type}


  end
end
