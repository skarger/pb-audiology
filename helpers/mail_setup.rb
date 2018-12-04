# frozen_string_literal: true

# General setup for sending email
module MailSetup
  Mail.defaults do
    smtp_server = "smtp.gmail.com"
    user_name = ENV["GOOGLE_USERNAME"]
    password = ENV["GOOGLE_PASSWORD"]
    port = 587

    delivery_method(:smtp,
                    address: smtp_server,
                    port: port,
                    domain: ENV["EMAIL_DOMAIN"],
                    enable_starttls_auto: true,
                    authentication: "plain",
                    user_name: user_name,
                    password: password)
  end

  def send_live_email?
    ENV["RACK_ENV"] == "development" && ENV["EMAIL_IN_DEVELOPMENT"] == "true" ||
      ENV["RACK_ENV"] == "staging" && ENV["EMAIL_IN_STAGING"] == "true" ||
      ENV["RACK_ENV"] == "production"
  end
end
