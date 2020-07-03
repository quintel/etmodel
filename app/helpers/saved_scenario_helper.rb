# frozen_string_literal: true

# Helper methods for saved scenario page
module SavedScenarioHelper
  def share_by_mail_link(scenario = nil)
    "mailto:
      ?subject=#{t('scenario.share.email_subject')} #{scenario&.title}
      &body=#{t('scenario.share.message')} #{request.original_url}"
  end

  def share_by_twitter_link
    "http://www.twitter.com/share?url=#{request.original_url}"
  end

  def share_by_linkedin_link
    "http://www.linkedin.com/shareArticle?mini=true&url=#{request.original_url}"
  end

  def share_by_facebook_link
    "http://www.facebook.com/sharer.php?u=#{request.original_url}"
  end

  def open_attributes
    { rel: 'noopener noreferrer',
      target: '_blank' }
  end

  def area_flag(area_code)
    area = Api::Area.find_by_country_memoized(area_code)

    return unless area.country? && area.area != 'UKNI01_northern_ireland'

    capture_haml do
      haml_tag(
        'img',
        src: icon_for_area_code(area_code),
        title: I18n.t("areas.#{area_code}"),
        width: 16
      )
    end
  end
end
