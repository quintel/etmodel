# frozen_string_literal: true

module MyEtm
  # Messages such as planned maintenance notices, configured per version in the MyETM admin panel.
  # Only those of the version this ETModel runs as (ETModel::Version::TAG) are shown.
  #
  # The banner is never important enough to break a page, so a failure to reach MyETM is reported
  # and treated as "no announcements".
  class Announcement < ActiveResource::Base
    self.site = "#{Settings.identity.issuer}/api/v1"

    # Announcements are fetched while rendering a page, so a slow MyETM may not hold up the
    # response.
    self.timeout = 2

    CACHE_TTL = 5.minutes

    def self.all_active
      Rails.cache.fetch(:announcements, expires_in: CACHE_TTL) do
        find(:all, params: { version: ETModel::Version::TAG }).to_a
      end
    rescue StandardError => e
      Sentry.capture_exception(e)
      []
    end

    # The message in the given locale, falling back to the other language when it is untranslated.
    def body(locale)
      locale.to_s == 'nl' ? body_nl.presence || body_en : body_en.presence || body_nl
    end
  end
end
