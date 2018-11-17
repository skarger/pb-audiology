# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require "logger"
require "server"

use Rack::Logger
run Server.freeze.app

