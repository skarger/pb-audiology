# frozen_string_literal: true

require "roda"
require "digest"

$LOAD_PATH.unshift File.dirname(__FILE__)
require "dependencies"

# The server app entrypoint. We boot it from config.ru.
# See http://roda.jeremyevans.net/ for information about the Roda framework.
# rubocop:disable Metrics/ClassLength
class Server < Roda
  plugin :caching
  plugin :public, gzip: true, default_mime: "text/html"
  plugin :head
  plugin :request_headers
  plugin :sessions, secret: ENV["SESSION_SECRET"], key: ENV["SESSION_KEY"]
  plugin :render, escape: true
  plugin :partials

  HEADERS = if %w[production staging].include?(ENV["RACK_ENV"])
              max_age = ENV["STRICT_TRANSPORT_SECURITY_MAX_AGE"]
              # rubocop:disable Metrics/LineLength
              { "Strict-Transport-Security" => "max-age=#{max_age}; includeSubDomains" }
              # rubocop:enable Metrics/LineLength
            else
              {}
            end
  plugin :default_headers, HEADERS

  def layout_locals(request)
    LAYOUT_LOCALS.merge(current_path: request.path)
  end

  route do |r|
    unless r.ssl? || %w[test development].include?(ENV["RACK_ENV"])
      host = r.host
      path = r.fullpath
      location = "https://#{host}#{path}"

      r.on method: %i[get head] do
        r.redirect(location, 302)
      end

      r.on do
        r.redirect(location, 307)
      end
    end

    r.public

    r.root do
      etag = Digest::SHA1.hexdigest(File.mtime("./views/home.erb").to_s)
      r.etag(etag, weak: true)
      view("home", layout_opts: { locals: layout_locals(r) })
    end

    r.is "contact" do
      first_name = r.session["contact_request_first_name"]
      last_name = r.session["contact_request_last_name"]
      email = r.session["contact_request_email"]
      phone = r.session["contact_request_phone"]
      message = r.session["contact_request_message"]
      contact_request_result = r.session["contact_request_result"]

      # capture values to display in the form immediately after submit,
      # clear session if successful so future page visits show an empty form
      clear_session if contact_request_result == "success"

      view("contact",
           layout_opts: { locals: layout_locals(r) },
           locals: CONTACT_PAGE_LOCALS.merge(
             contact_request_result: contact_request_result,
             contact_request_first_name: first_name,
             contact_request_last_name: last_name,
             contact_request_email: email,
             contact_request_phone: phone,
             contact_request_message: message
           ))
    end

    r.is "contact_requests" do
      r.get do
        # if there has been a previous attempt, we want to show a
        # message informing the user of success or failure
        contact_request_result = r.session["contact_request_result"]

        # recover form data if present
        full_name = r.session["contact_request_full_name"]
        email = r.session["contact_request_email"]
        phone = r.session["contact_request_phone"]
        message = r.session["contact_request_message"]

        # we will show the filled form immediately after a successful attempt,
        # but then we clear session so future page visits show an empty form
        clear_session if contact_request_result == "success"

        view("contact_requests",
             layout_opts: { locals: layout_locals(r) },
             locals: LAYOUT_LOCALS.merge(
               contact_request_result: contact_request_result,
               contact_request_full_name: full_name,
               contact_request_email: email,
               contact_request_phone: phone,
               contact_request_message: message
             ))
      end

      r.post do
        r.session["contact_request_full_name"] = r.params["full_name"]
        r.session["contact_request_email"] = r.params["email"]
        r.session["contact_request_phone"] = r.params["phone"]
        r.session["contact_request_message"] = r.params["message"]

        email_body = render("contact_request_email",
                            locals: {
                              full_name: r.params["full_name"],
                              email: r.params["email"],
                              phone: r.params["phone"],
                              message: r.params["message"]
                            })

        begin
          ContactRequestMailer.call(
            full_name: r.params["full_name"],
            email: r.params["email"],
            phone: r.params["phone"],
            body: email_body
          )
          r.session["contact_request_result"] = "success"
        rescue StandardError
          r.session["contact_request_result"] = "failure"
        end

        begin
          r.persist_session(r.env, r.session)
        rescue Roda::RodaPlugins::Sessions::CookieTooLarge => error
          raise error
        end

        r.redirect "/contact_requests"
      end
    end

    r.is "about" do
      view("about", layout_opts: { locals: layout_locals(r) })
    end

    r.is "faq" do
      view("faq", layout_opts: { locals: layout_locals(r) })
    end
  end
end
# rubocop:enable Metrics/ClassLength
