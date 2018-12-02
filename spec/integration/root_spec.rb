# frozen_string_literal: true

require "support/rack_test_helper"

RSpec.describe "All requests" do
  include RackTestHelper

  let(:test_rack_env_http) { test_rack_env.merge("rack.url_scheme" => "http") }

  describe "redirect to SSL" do
    before do
      @original_env = ENV["RACK_ENV"]
    end

    after do
      ENV["RACK_ENV"] = @original_env
    end

    describe "GET and HEAD respond with 302" do
      %w[get head].each do |verb|
        %w[staging production].each do |env|
          it "#{verb.upcase} redirects in the #{env} environment" do
            ENV["RACK_ENV"] = env

            request = "#{verb} '/', {}, test_rack_env_http"
            eval(request) # rubocop:disable Security/Eval

            expect(last_response.status).to eq(302)
            expect(last_response.headers["LOCATION"])
              .to eq("https://example.org/")
          end
        end

        %w[test development].each do |env|
          it "#{verb.upcase} does not redirect in the #{env} environment" do
            ENV["RACK_ENV"] = env

            request = "#{verb} '/', {}, test_rack_env_http"
            eval(request) # rubocop:disable Security/Eval

            expect(last_response.status).to eq(200)
          end
        end
      end
    end

    describe "PUT and POST respond with 307" do
      %w[put post].each do |verb|
        %w[staging production].each do |env|
          it "#{verb.upcase} redirects in the #{env} environment" do
            ENV["RACK_ENV"] = env

            request = "#{verb} '/', {}, test_rack_env_http"
            eval(request) # rubocop:disable Security/Eval

            expect(last_response.status).to eq(307)
            expect(last_response.headers["LOCATION"])
              .to eq("https://example.org/")
          end
        end
      end
    end
  end
end
