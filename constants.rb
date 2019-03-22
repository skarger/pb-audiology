# frozen_string_literal: true

PROVIDER_NAME = "Pauline G. Bailey"
PROVIDER_CREDENTIALS = "MA FAAA"
TELEPHONE = "(203) 329-2449"
STREET_ADDRESS = "104 Newfield Drive"
ADDRESS_LOCALITY = "Stamford"
ADDRESS_REGION = "CT"
POSTAL_CODE = "06905"
GOOGLE_MAPS_LINK = "https://www.google.com/maps/place/104+Newfield+Dr,+Stamford,+CT+06905/@41.1084539,-73.5362619"

CONTACT_INFO = {
  telephone: TELEPHONE,
  street_address: STREET_ADDRESS,
  address_locality: ADDRESS_LOCALITY,
  address_region: ADDRESS_REGION,
  postal_code: POSTAL_CODE,
  google_maps_link: GOOGLE_MAPS_LINK
}.freeze

LAYOUT_LOCALS = {
  provider_name: PROVIDER_NAME,
  provider_credentials: PROVIDER_CREDENTIALS
}.merge(CONTACT_INFO).freeze

GOOGLE_MAPS_QUERY = "104+Newfield+Drive,Stamford+CT+06905"
GOOGLE_MAPS_EMBED_URL = "https://www.google.com/maps/embed/v1/place" \
  "?key=#{ENV['GOOGLE_API_KEY']}" \
  "&q=#{GOOGLE_MAPS_QUERY}" \
  "&zoom=11" \
  "&attribution_source=Google+Maps+Embed+API" \
  "&attribution_web_url=#{ENV['PUBLIC_URL']}" \
  "attribution_ios_deep_link_id=comgooglemaps://?daddr=#{GOOGLE_MAPS_QUERY}"

CONTACT_PAGE_LOCALS = {
  google_maps_embed_url: GOOGLE_MAPS_EMBED_URL
}.merge(CONTACT_INFO).freeze
