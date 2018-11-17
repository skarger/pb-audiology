# frozen_string_literal: true

require 'roda'

# The server app entrypoint. We boot it from config.ru.
# See http://roda.jeremyevans.net/ for information about the Roda framework.
class Server < Roda
  plugin :public, gzip: true, default_mime: 'text/html'
  plugin :render

  route do |r|
    r.public

    r.root do
      render('home')
    end
  end
end
