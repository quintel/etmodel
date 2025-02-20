module MyEtm
  class Version < ActiveResource::Base
    self.site = "#{Settings.identity.issuer}/api/v1"

    def self.all_other_versions
      return [] if Settings.version == "beta" # Don't show versions in beta

      Rails.cache.fetch(:api_versions) do
        find(:all).reject { |v| v.tag == ETModel::Version::TAG }
      end
    end
  end
end
