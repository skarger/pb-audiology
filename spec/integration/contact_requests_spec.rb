# frozen_string_literal: true

require "support/rack_test_helper"

RSpec.describe "Requests to /contact_requests" do
  include RackTestHelper

  describe "POST /contact_requests" do
    it "responds with a temporary redirect" do
      post "/contact_requests", {}, test_rack_env

      expect(last_response.status).to eq(302)
    end
  end

  describe "GET /contact_requests" do
    it "responds with 200" do
      get "/contact_requests", {}, test_rack_env

      expect(last_response.status).to eq(200)
    end
  end
end
