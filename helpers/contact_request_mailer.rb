# frozen_string_literal: true

# Helper to send email to provider when visitor submits a contact request
class ContactRequestMailer
  include MailSetup

  def self.call(full_name:, phone: nil, email:, body:)
    new(full_name: full_name, phone: phone, email: email, body: body).call
  end

  def initialize(full_name:, phone: nil, email:, body:)
    @full_name = full_name
    @phone = phone
    @email = email
    @body = body
  end

  attr_reader :full_name, :phone, :email, :body

  def call
    email_to_provider.deliver! if send_live_email?
  end

  def email_to_provider
    subject = "WEBSITE CONTACT REQUEST from #{full_name}"
    body = self.body

    Mail.new do
      from(ENV["CONTACT_NOTIFICATION_EMAIL_DESTINATION"])
      to(ENV["CONTACT_NOTIFICATION_EMAIL_DESTINATION"])
      subject(subject)
      body(body)
    end
  end
end
