# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

# we need to load environment before loading server.rb
unless %(production staging).include?(ENV['RACK_ENV'])
  require 'dotenv'
  Dotenv.load
end

require 'logger'
require 'server'

use Rack::Logger
use Rack::ConditionalGet
run Server.freeze.app
