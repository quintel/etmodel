module Admin
  class PagesController < BaseController
    def index
    end

    def clear_cache
      Rails.cache.clear
      redirect_to admin_root_path, :notice => 'Cache cleared'
    end

    def wattnu_log
      send_file Rails.root.join("log/tracking.log"),
        :filename => 'log.txt',
        :type => 'text/plain',
        :disposition => 'inline'
    end

    def clear_wattnu_log
      Tracker.instance.clear_log
      render :text => "log clear"
    end
  end
end
