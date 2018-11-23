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

  NAME = 'Pauline G. Bailey'
  CREDENTIALS = 'MA FAAA'
  TELEPHONE = '(203) 329-2449'
  STREET_ADDRESS = '104 Newfield Drive'
  ADDRESS_LOCALITY = 'Stamford'
  ADDRESS_REGION = 'CT'
  POSTAL_CODE = '06905'

  LAYOUT_LOCALS = {
    telephone: TELEPHONE,
    street_address: STREET_ADDRESS,
    address_locality: ADDRESS_LOCALITY,
    address_region: ADDRESS_REGION,
    postal_code: POSTAL_CODE
  }.freeze

  route do |r|
    r.public

    r.root do
      etag = Digest::SHA1.hexdigest(File.mtime('./views/home.erb').to_s)
      r.etag(etag, weak: true)
      render('home')
    end

    r.is 'example' do
      view('example', layout_opts: { locals: LAYOUT_LOCALS })
    end

    r.is 'contact' do
      view('contact', layout_opts: { locals: LAYOUT_LOCALS })
    end
  end
end
