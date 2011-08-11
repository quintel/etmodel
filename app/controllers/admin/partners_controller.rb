module Admin
  class PartnersController < BaseController
    before_filter :find_partner, :only => [:show, :edit, :update, :destroy]

    def index
      @partners = Partner.all
    end

    def new
      @partner = Partner.new
    end

    def create
      @partner = Partner.new(params[:partner])
      if @partner.save
        flash[:notice] = "Partner created"
        redirect_to admin_partner_path(@partner)
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @partner.update_attributes(params[:partner])
        redirect_to admin_partner_path(@partner), :notice => 'partner updated'
      else
        render :edit
      end
    end

    def destroy
      @partner.destroy
      redirect_to admin_partners_path, :notice => "partner deleted"
    end

    private

      def find_partner
        @partner = Partner.find(params[:id])
      end
  end
end
