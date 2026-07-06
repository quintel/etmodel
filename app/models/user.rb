# A registered user.
class User < ApplicationRecord
  ROLES = {
    1 => :scenario_viewer,
    2 => :scenario_collaborator,
    3 => :scenario_owner
  }.freeze

  attr_accessor :identity_user

  delegate :email, :roles, :admin?, to: :identity_user, allow_nil: true

  has_one  :survey, dependent: :destroy

  validates :name, presence: true

  scope :ordered, -> { order('name') }

  # Finds or creates a user from a JWT token.
  #
  # The token's claims are also set as identity_user: email/roles/admin? all prefer this fresh,
  # per-request identity data over the persisted columns, which are only ever set at creation, so a
  # role granted/revoked at the identity provider after that first login is still reflected here.
  def self.from_jwt!(token)
    id = token['sub']
    name = token.dig('user', 'name')

    raise 'Token does not contain user information' unless id.present? && name.present?

    user = User.find_or_create_by!(id: id) { |u| u.name = name }
    user.identity_user = Identity::User.from_jwt_claims(token)
    user
  end
end
