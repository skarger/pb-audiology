# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'logger'
require 'server'

use Rack::Logger
use Rack::ETag
use Rack::ConditionalGet
run Server.freeze.app
