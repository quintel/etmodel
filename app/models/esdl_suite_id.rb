# frozen_string_literal: true

# Represents a Users OpenId for the ESDL Suite
class EsdlSuiteId < ApplicationRecord
  belongs_to  :user

  validates   :id_token, presence: true
  validates   :access_token, presence: true
  validates   :refresh_token, presence: true

  def expired?
    return true unless expires_at

    expires_at < Time.zone.now
  end

  # Refreshes the EsdlSuiteId OpenId tokens if possible, else removes this EsdlSuiteId
  def refresh
    new_token = EsdlSuiteService.setup.refresh(to_access_token)
    return delete if new_token.empty?

    update(new_token)
  end

  # Returns true if the EsdlSuiteId can be used for communication
  # Returns false if the EsdlSuiteId has expired and is unable to refresh
  def fresh?
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
