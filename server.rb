# frozen_string_literal: true

require 'roda'
require 'digest'

# The server app entrypoint. We boot it from config.ru.
# See http://roda.jeremyevans.net/ for information about the Roda framework.
class Server < Roda
  plugin :public, gzip: true, default_mime: 'text/html'
  plugin :caching
  plugin :render
  plugin :partials

  HEADERS = if %(production staging).include?(ENV['RACK_ENV'])
              max_age = ENV['STRICT_TRANSPORT_SECURITY_MAX_AGE']
              # rubocop:disable Metrics/LineLength
              { 'Strict-Transport-Security' => "max-age=#{max_age}; includeSubDomains" }
              # rubocop:enable Metrics/LineLength
            else
              {}
            end
  plugin :default_headers, HEADERS

  NAME = 'Pauline G. Bailey'
  CREDENTIALS = 'MA FAAA'
  TELEPHONE = '(203) 329-2449'
  STREET_ADDRESS = '104 Newfield Drive'
  ADDRESS_LOCALITY = 'Stamford'
  ADDRESS_REGION = 'CT'
  POSTAL_CODE = '06905'

  LAYOUT_LOCALS = {
    name: NAME,
    credentials: CREDENTIALS,
    telephone: TELEPHONE,
    street_address: STREET_ADDRESS,
    address_locality: ADDRESS_LOCALITY,
    address_region: ADDRESS_REGION,
    postal_code: POSTAL_CODE
  }.freeze

  GOOGLE_MAPS_QUERY = '104+Newfield+Drive,Stamford+CT+06905'
  GOOGLE_MAPS_EMBED_URL = 'https://www.google.com/maps/embed/v1/place' \
    "?key=#{ENV['GOOGLE_API_KEY']}" \
    "&q=#{GOOGLE_MAPS_QUERY}" \
    '&zoom=12' \
    '&attribution_source=Google+Maps+Embed+API' \
    "&attribution_web_url=#{ENV['PUBLIC_URL']}" \
    "attribution_ios_deep_link_id=comgooglemaps://?daddr=#{GOOGLE_MAPS_QUERY}"
  CONTACT_PAGE_LOCALS = {
    google_maps_embed_url: GOOGLE_MAPS_EMBED_URL
  }.freeze

  def layout_locals(request)
    LAYOUT_LOCALS.merge(current_path: request.path)
  end

  route do |r|
    r.public

    r.root do
      etag = Digest::SHA1.hexdigest(File.mtime('./views/home.erb').to_s)
      r.etag(etag, weak: true)
      view('home', layout_opts: { locals: layout_locals(r) })
    end

    r.is 'contact' do
      view('contact',
           layout_opts: { locals: layout_locals(r) },
           locals: CONTACT_PAGE_LOCALS)
    end

    r.is 'about' do
      view('about', layout_opts: { locals: layout_locals(r) })
    end

    r.is 'faq' do
      view('faq', layout_opts: { locals: layout_locals(r) })
    end
  end
end
