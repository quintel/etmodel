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

  def owned_saved_scenario?(saved_scenario)
    saved_scenario.user_id == current_user&.id
  end
end
