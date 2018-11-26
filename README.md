# PB Audiology

Source code for an audiology practice's website.

<!-- toc -->

- [Components](#components)
  * [Ruby web application](#ruby-web-application)
    + [Setup](#setup)
    + [Run the development server](#run-the-development-server)
- [Deployment](#deployment)
  * [Buildpacks](#buildpacks)

<!-- tocstop -->

To regenerate the table of contents run `yarn markdown-toc -i README.md`

# Components

## Ruby web application

This app exists primarily to serve content pages, but has the potential to provide additional server-side functionality if needed.

We build the app on top of the [Roda framework](http://roda.jeremyevans.net/).

It follows the conventions for a Small Application [outlined in the Roda docs](http://roda.jeremyevans.net/rdoc/files/doc/conventions_rdoc.html).

The app has static assets that we manage with Node, using [Webpack](https://webpack.js.org/).

### Setup

Install Node and Yarn.

Install NPM packages:
```
yarn
```

Compile assets, and watch for changes:
```
yarn watch
```

Install Ruby and Bundler.

Install gems:
```
bundle install
```

Install git hooks that will run rubocop on commit:
```
bundle exec overcommit --install
```

Environment: Create a `.env` file. Copy `.env.example`

We use the Google Maps API to embed a map with the office location.

Obtain a development Google API key. Someone with access to our [Google Cloud console](https://console.cloud.google.com/apis/credentials?organizationId=0&project=pb-audiology) must provide the key. The in `.env`, create an entry for it:

```
GOOGLE_API_KEY=...
```

### Run the development server

We use the [Rerun](https://github.com/alexch/rerun) gem to automatically restart the app when files change. To run the web server:
```
rerun -- bundle exec puma -v -C config/puma.rb
```

# Deployment

We host the app on [Heroku](https://www.heroku.com/).

## Buildpacks

The app requires the `heroku/nodejs` and `heroku/ruby` [buildpacks](https://devcenter.heroku.com/articles/buildpacks), in that order. The Node buildpack compiles the assets on deploy. The Ruby buildpack sets up and runs the server application.

## Third-party services

* Heroku to host the application
* Google APIs to embed a map
* Google Domains to register the domain name and configure DNS settings
* Google G Suite to provide email (`@auditoryprocessingservces.com`)

### Email Notes
When people submit a question via the contact form, we send an email to the business owner.

In order to make this possible, G Suite needs a non-default setting, configured via https://admin.google.com:
In Security > Advanced security settings > Less secure apps, we need to set "Allow users to manage their access to less secure apps."

This enables the web server to send email on via the business owner's address. Because we use 2FA for G Suite, the business owner must generate an app password in order to let the web app authenticate. That app password is provided to the web app in an enviroment variable, following our standard approach to sensitive credentials.

See https://stackoverflow.com/questions/33918448/ruby-sending-mail-via-gmail-smtp for details on gmail authentication setup.

