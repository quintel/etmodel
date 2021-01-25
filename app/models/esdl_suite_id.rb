# frozen_string_literal: true

# Represents a Users OpenId for the ESDL Suite
class EsdlSuiteId < ApplicationRecord
  belongs_to  :user

  validates   :access_token, presence: true
  validates   :refresh_token, presence: true
  validates   :user_id, uniqueness: true

  def expired?
    return true unless expires_at

    expires_at < Time.zone.now
  end

  # Internal: Refreshes the EsdlSuiteId OpenId tokens if possible, else removes this EsdlSuiteId.
  # When the refresh token expires, we cannot refresh the access token anymore and the EsdlSuiteId
  # becomes unusable. Hence we delete the instance.
  def refresh
    new_token = EsdlSuiteService.setup.refresh(to_access_token)
    return delete if new_token.empty?

    update(new_token)
  end

  # Public: Evaluates if the EsdlSuiteId can still be used for communication. Has a side-effect of
  # deleting the instance when refreshing is impossible
  #
  # Returns true if the EsdlSuiteId can be used for communication
  # Returns false if the EsdlSuiteId has expired and is unable to refresh
  def try_viable
    refresh if expired?

    persisted?
  end

  def self.create_or_update(attributes)
    existing_id = attributes[:user].esdl_suite_id
    return existing_id.update(attributes) if existing_id

    create(attributes)
  end

  private

  def client
    basic_client = EsdlSuiteService.setup.client
    basic_client.refresh_token = refresh_token

    basic_client
  end

  def to_access_token
    OpenIDConnect::AccessToken.new(
      access_token: access_token,
      client: client
    )
  end
end
