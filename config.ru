# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'logger'
require 'server'

use Rack::Logger
use Rack::ConditionalGet
use Rack::ETag
run Server.freeze.app
