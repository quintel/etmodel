# frozen_string_literal: true

module ETModel
  module Version
    # Release tag
    TAG = Settings.version

    # Year of release.
    MAJOR = 2025

    # Month of release.
    MINOR = 05

    # Day of release. This is not used in version numbers but is required to build the DATE_VERSION
    # so that we know the exact date. This should be the day on which the minor version was released,
    # not incremented for each small change.
    DAY = 1

    STRING = format('%<major>d.%<minor>02d', major: MAJOR, minor: MINOR)
    DATE = Date.new(MAJOR, MINOR, DAY)

    def self.prerelease?
      DATE > Time.now.utc
    end
  end
end
