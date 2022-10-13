# frozen_string_literal: true

# Shows the contact form, and sends messages to the e-mail address.
class ContactController < ApplicationController
  skip_before_action :initialize_current

  invisible_captcha(
    only: [:send_message],
    honeypot: :country,
    on_spam: :send_feedback_spam
  )

  def index
    @message = ContactUsMessage.new
  end

  def send_message
    @message = ContactUsMessage.from_params(params)

    if @message.valid?
      ContactUsMailer.contact_email(@message).deliver

      flash[:notice] = t('pages.contact.success_flash')
      redirect_to contact_url
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def send_feedback_spam
    @message = ContactUsMessage.from_params(params)
    @message.valid?

    render :index, status: :unprocessable_entity
  end
end
