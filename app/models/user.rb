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

  # Performs sign-in steps for an Identity::User.
  #
  # If a matching user exists in the database, it will be updated with the latest data from the
  # Identity::User. Otherwise, a new user will be created.
  #
  # Returns the user. Raises an error if the user could not be saved.
  def self.from_identity!(identity_user)
    where(id: identity_user.id).first_or_initialize.tap do |user|
      is_new_user = !user.persisted?
      user.identity_user = identity_user
      user.name = identity_user.name

      user.save!
    end
  end

  # Finds or creates a user from a JWT token.
  def self.from_jwt!(token)
    id = token['sub']
    name = token.dig('user', 'name')

    raise 'Token does not contain user information' unless id.present? && name.present?

    User.find_or_create_by!(id: token['sub']) { |u| u.name = name }
  end

  def self.from_session_user!(identity_user)
    find(identity_user.id).tap { |u| u.identity_user = identity_user }
  end
end
