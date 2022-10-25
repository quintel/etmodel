# frozen_string_literal: true

# Shows the contact form, and sends messages to the e-mail address.
class ContactController < ApplicationController
  before_action :require_feedback_email
  skip_before_action :initialize_current

  invisible_captcha(
    only: [:send_message],
    honeypot: :country,
    on_spam: :send_feedback_spam
  )

  def index
    @message = ContactUsMessage.new(name: current_user&.name, email: current_user&.email)
  end

  def send_message
    @message = ContactUsMessage.from_params(params)

    if @message.valid?
      ContactUsMailer.contact_email(
        @message,
        locale: I18n.locale,
        user_agent: request.env['HTTP_USER_AGENT']
      ).deliver

      flash[:notice] = t('pages.contact.success_flash')
      redirect_to contact_url
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def require_feedback_email
    redirect_to(root_url) unless Settings.feedback_email
  end

  def send_feedback_spam
    @message = ContactUsMessage.from_params(params)
    @message.valid?

    render :index, status: :unprocessable_entity
  end
end
