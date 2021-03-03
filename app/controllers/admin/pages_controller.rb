module Admin
  class PagesController < BaseController
    def index
    end

    def clear_cache
      Rails.cache.clear
      redirect_to admin_root_path, notice: 'Cache cleared'
    end

    def surveys
      csv = CSV.generate do |builder|
        builder << Survey::CSV_COLUMNS

        Survey.find_each do |survey|
          builder << survey.attributes.values_at(*Survey::CSV_COLUMNS)
        end
      end

      send_data(
        csv,
        type: 'text/csv; charset=utf-8; header=present',
        disposition: 'attachment; filename=surveys.csv'
      )
    end
  end
end
