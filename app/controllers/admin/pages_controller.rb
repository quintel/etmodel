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
        builder << [:id, :user_id, *Survey::QUESTIONS.map(&:key)]

        Survey.find_each do |survey|
          builder << [
            survey.id,
            survey.user_id,
            *Survey::QUESTIONS.map { |q| survey.localized_answer_for(q) }
          ]
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
