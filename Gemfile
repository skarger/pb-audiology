# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.5.3"

gem "erubi" # required for :escape option to Roda render plugin
gem "mail"
gem "puma"
gem "roda"
gem "tilt"

group :test, :development do
  gem "dotenv"
  gem "pry"
  gem "rerun"
  gem "rubocop", require: false
end

group :development do
  gem "overcommit"
  gem "yard"
end

group :test do
  gem "rack-test"
  gem "rspec"
end
