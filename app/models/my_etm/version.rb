module MyEtm
  class Version < ActiveResource::Base
    self.site = "#{Settings.identity.issuer}/api/v1"

    # The name the version is shown by. MyETM sends it with the tag.
    def label
      attributes['label'] || tag
    end

    # The versions in the version picker, latest first, then the newest.
    #
    # The list comes from MyETM and is cached for an hour, as latest's release date changes with
    # each release. MyETM leaves out hidden versions, so a hidden version adds itself. Beta lists
    # only itself, with latest's release date.
    def self.listed
      versions = Rails.cache.fetch(:myetm_versions, expires_in: 1.hour) { find(:all).to_a }

      if Settings.version == 'beta'
        released_on = versions.find(&:latest?)&.released_on
        return [new(tag: ETModel::Version::TAG, released_on: released_on&.iso8601)]
      end

      versions += [new(tag: ETModel::Version::TAG)] if versions.none?(&:current?)

      latest, others = versions.partition(&:latest?)
      latest + others.sort_by(&:tag).reverse
    end

    def released_on
      attributes['released_on'] && Date.iso8601(attributes['released_on'])
    end

    def latest?
      tag == 'latest'
    end

    def beta?
      tag == 'beta'
    end

    # The version this ETModel runs as.
    def current?
      tag == ETModel::Version::TAG
    end

    # Latest and beta are shown by their release date, the others by their label.
    def name
      (latest? || beta?) && released_on ? I18n.l(released_on, format: :long) : label
    end

    # The name on the closed picker: latest and beta by their badge, the others by their name.
    def short_name
      latest? || beta? ? I18n.t("versions.#{badge}").upcase_first : name
    end

    # The badge next to the name. None for a stable version MyETM doesn't list.
    def badge
      if latest? then :latest
      elsif beta? then :beta
      elsif persisted? then :stable
      end
    end
  end
end
