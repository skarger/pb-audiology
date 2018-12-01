# frozen_string_literal: true

require 'support/rack_test_helper'

RSpec.describe 'Requests to /contact_requests' do
  include RackTestHelper

  describe "POST /contact_requests" do
    it "responds" do
      post '/contact_requests', {}, test_rack_env

      expect(last_response.status).to eq(201)
    end
  end
end
