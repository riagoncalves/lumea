require "faraday"

Faraday.default_connection = Faraday.new do |f|
  f.request :json
  f.response :json, content_type: /\bjson$/
  f.adapter Faraday.default_adapter
end
