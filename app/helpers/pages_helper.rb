module PagesHelper
  # Public: Determines if the "What's new in the ETM?" banner should be shown
  # in staging and production environments.
  def show_whats_new_banner?
    if APP_CONFIG[:whats_new_cutoff]
      Date.today < APP_CONFIG[:whats_new_cutoff]
    else
      Rails.env.development?
    end
  end
end
