# frozen_string_literal: true

require "dependencies"

RSpec.describe "ContactRequestMailer" do
  describe "#call" do
    shared_examples_for "does not send email" do
      it "does not call Mail.new" do
        allow(Mail).to receive(:new)

        ContactRequestMailer.call(full_name: "First Last",
                                  email: "first.last@example.com",
                                  phone: "617-123-4567",
                                  body: "Do you accept cash?")

        expect(Mail).not_to have_received(:new)
      end
    end

    shared_examples_for "sends email" do
      it "does deliver! a mail" do
        expected = Mail.new do
          from(ENV["CONTACT_NOTIFICATION_EMAIL_DESTINATION"])
          to(ENV["CONTACT_NOTIFICATION_EMAIL_DESTINATION"])
          subject("WEBSITE CONTACT REQUEST from First Last}")
          body("Do you accept cash?")
        end

        allow(expected).to receive(:deliver!)
        allow(Mail).to receive(:new).and_return(expected)

        ContactRequestMailer.call(full_name: "First Last",
                                  email: "first.last@example.com",
                                  phone: "617-123-4567",
                                  body: "Do you accept cash?")

        expect(expected).to have_received(:deliver!)
      end
    end

    context "test environment" do
      it_behaves_like "does not send email"
    end

    context "development environment" do
      before do
        @original_env = ENV["RACK_ENV"]
        ENV["RACK_ENV"] = "development"
      end

      after do
        ENV["RACK_ENV"] = @original_env
      end

      context "when EMAIL_IN_DEVELOPMENT nil" do
        before do
          @original_email_in_development = ENV["EMAIL_IN_DEVELOPMENT"]
          ENV["EMAIL_IN_DEVELOPMENT"] = nil
        end

        after do
          ENV["EMAIL_IN_DEVELOPMENT"] = @original_email_in_development
        end

        it_behaves_like "does not send email"
      end

      context "when EMAIL_IN_DEVELOPMENT == 'false'" do
        before do
          @original_email_in_development = ENV["EMAIL_IN_DEVELOPMENT"]
          ENV["EMAIL_IN_DEVELOPMENT"] = "false"
        end

        after do
          ENV["EMAIL_IN_DEVELOPMENT"] = @original_email_in_development
        end

        it_behaves_like "does not send email"
      end

      context "when EMAIL_IN_DEVELOPMENT == 'true'" do
        before do
          @original_email_in_development = ENV["EMAIL_IN_DEVELOPMENT"]
          ENV["EMAIL_IN_DEVELOPMENT"] = "true"
        end

        after do
          ENV["EMAIL_IN_DEVELOPMENT"] = @original_email_in_development
        end

        it_behaves_like "sends email"
      end
    end

    context "staging environment" do
      before do
        @original_env = ENV["RACK_ENV"]
        ENV["RACK_ENV"] = "staging"
      end

      after do
        ENV["RACK_ENV"] = @original_env
      end

      context "when EMAIL_IN_STAGING nil" do
        before do
          @original_email_in_staging = ENV["EMAIL_IN_STAGING"]
          ENV["EMAIL_IN_STAGING"] = nil
        end

        after do
          ENV["EMAIL_IN_STAGING"] = @original_email_in_staging
        end

        it_behaves_like "does not send email"
      end

      context "when EMAIL_IN_STAGING == 'false'" do
        before do
          @original_email_in_staging = ENV["EMAIL_IN_STAGING"]
          ENV["EMAIL_IN_STAGING"] = "false"
        end

        after do
          ENV["EMAIL_IN_STAGING"] = @original_email_in_staging
        end

        it_behaves_like "does not send email"
      end

      context "when EMAIL_IN_STAGING == 'true'" do
        before do
          @original_email_in_staging = ENV["EMAIL_IN_STAGING"]
          ENV["EMAIL_IN_STAGING"] = "true"
        end

        after do
          ENV["EMAIL_IN_STAGING"] = @original_email_in_staging
        end

        it_behaves_like "sends email"
      end
    end

    context "product environment" do
      before do
        @original_env = ENV["RACK_ENV"]
        ENV["RACK_ENV"] = "production"
      end

      after do
        ENV["RACK_ENV"] = @original_env
      end

      it_behaves_like "sends email"
    end
  end
end
