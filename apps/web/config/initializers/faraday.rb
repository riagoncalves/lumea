require 'faraday'
require 'faraday/middleware'

Faraday.default_connection = Faraday.new do |f|
  f.request :json
  f.response :json, content_type: /\bjson$/
  f.request :retry, max: 3, interval: 0.05
  f.adapter Faraday.default_adapter
end
