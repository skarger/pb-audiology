# frozen_string_literal: true

require "mail"
require "pry"
require "dotenv/load"

smtp_server = "smtp.gmail.com"
user_name = ENV["GOOGLE_USERNAME"]
password = ENV["GOOGLE_PASSWORD"]
port = 587

Mail.defaults do
  delivery_method(:smtp,
                  address: smtp_server,
                  port: port,
                  domain: "localhost",
                  enable_starttls_auto: true,
                  authentication: "plain",
                  user_name: user_name,
                  password: password)
end

name = "Big Cat Little Cat"
message = "My message #{name}"

mail = Mail.new do
  from(user_name)
  to(ENV["CONTACT_NOTIFICATION_EMAIL_DESTINATION"].to_s)
  subject("WEBSITE CONTACT REQUEST from #{name}")
  body(message)
end

begin
  mail.deliver!
rescue StandardError => error
  puts error
end
