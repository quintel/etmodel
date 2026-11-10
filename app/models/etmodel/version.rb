# frozen_string_literal: true

module ETModel
  module Version
    # Release tag
    TAG = Settings.version

    # The day this version was released, from MyETM. Empty while the version is hidden.
    def self.date
      MyEtm::Version.listed.find(&:current?)&.released_on
    end
  end
end
