# frozen_string_literal: true

ContactUsMessage = Struct.new(:name, :email, :message, keyword_init: true) do
  include ActiveModel::Validations

  def self.from_params(params)
    new(name: params[:name], email: params[:email], message: params[:message])
  end

  validates :email,   presence: true, 'valid_email_2/email': true
  validates :message, presence: true

  validate :validate_email
  validate :validate_message

  private

  # Internal: Validates that the sender is not using our own domain. This is a strangely common
  # occurrence with spammers.
  def validate_email
    if email.to_s.strip.end_with?('@energytransitionmodel.com')
      errors.add(:email, :disallowed_domain)
    end
  end

  # Internal: Validates that the message doesn't contain words frequently used by spammers.
  def validate_message
    message = self[:message].to_s.downcase

    if message.match?(/\bdomain\b/) || message.match?(/\brenew\b/) || message.match?(/\bporn\b/)
      errors.add(:message, :disallowed_content)
    end
  end
end
