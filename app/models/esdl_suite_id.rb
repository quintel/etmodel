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

  # Retrieves the userinfo from the tokens. The userinfo contains the name,
  # email adress and other details of the User that is known at the ESDL Suite
  def userinfo
    refresh if expired?

    to_access_token.userinfo!
  end

  # Refreshes the EsdlSuiteId OpenId tokens if possible, else removes this EsdlSuiteId
  def refresh
    new_token = EsdlSuiteService.setup.refresh(to_access_token)
    return delete unless new_token

    update(new_token)
  end

  def fresh
    refresh if expired?

    self
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
