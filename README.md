# PB Audiology

Source code for an audiology practice's website.

<!-- toc -->
<!-- tocstop -->

# Components

## Ruby web service

We build the server on top of the [Roda framework](http://roda.jeremyevans.net/).

It follows the conventions for a Small Application [outlined in the Roda docs](http://roda.jeremyevans.net/rdoc/files/doc/conventions_rdoc.html).

### Run the development server

We use the [Rerun](https://github.com/alexch/rerun) gem to automatically restart the app when files change. To run the web server:

```
rerun -- bundle exec puma -C config/puma.rb
```

# Deployment

We host the app on [Heroku](https://www.heroku.com/).

## Buildpacks

The app requires the `heroku/ruby` [buildpack](https://devcenter.heroku.com/articles/buildpacks).

## Environment variables
