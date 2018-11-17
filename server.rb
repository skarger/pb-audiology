require "roda"

class Server < Roda
  plugin :public, gzip: true, default_mime: "text/html"
  plugin :render

  route do |r|
    r.public

    r.root do
      render("home")
    end
  end
end

