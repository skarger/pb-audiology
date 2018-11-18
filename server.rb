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

  route do |r|
    r.public

    r.root do
      etag = Digest::SHA1.hexdigest(File.mtime('./views/home.erb').to_s)
      r.etag(etag, weak: true)
      render('home')
    end
  end
end
