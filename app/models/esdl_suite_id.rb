class EsdlSuiteId < ApplicationRecord
  belongs_to  :user

  validates   :id_token, presence: true
  validates   :access_token, presence: true
  validates   :refresh_token, presence: true

  def expired?
    # TODO
  end

  def userinfo
    to_access_token.userinfo!
  rescue OpenIDConnect::Unauthorized
    # TODO: create refresh
  end

  def to_access_token
    OpenIDConnect::AccessToken.new(
      access_token: access_token,
      refresh_token: refresh_token,
      id_token: id_token,
      client: EsdlSuiteService.setup.client
    )
  end
end
