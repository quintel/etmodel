module Admin
  class PagesController < BaseController
    def index
    end

    def clear_cache
      Rails.cache.clear
      redirect_to admin_root_path, notice: 'Cache cleared'
    end
  end
end
