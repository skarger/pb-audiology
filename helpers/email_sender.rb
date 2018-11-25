# frozen_string_literal: true

require 'mail'
require 'dotenv/load'

smtp_server = 'smtp-relay.gmail.com'
user_name = ENV['GMAIL_USERNAME']
password = ENV['GMAIL_PASSWORD']
port = 587

Mail.defaults do
  delivery_method(:smtp,
                  address: smtp_server,
                  port: port,
                  user_name: user_name,
                  password: password)
end

n = 2
mail = Mail.new do
  to('stephen@auditoryprocessingaservices.com')
  subject("My subject #{n}")
  body("My message #{n}")
end

mail.deliver!
