require 'net/http'
require 'uri'
require 'json'

module ExternalServices
  class LogService < ApplicationService
    LOG_SERVICE_URL = ENV.fetch("LOG_SERVICE_URL")
    INTERNAL_API_SECRET = ENV.fetch("APP_SECRET_KEY")

    attr_accessor :user_id, :action, :entity_type, :entity_id, :old_values, :new_values

    def create_audit_log!
      uri = URI("#{LOG_SERVICE_URL}/audit_logs")
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = INTERNAL_API_SECRET
      req['Content-Type'] = 'application/json'
      req.body = {
        audit_log: {
          user_id: user_id,
          action: action,
          entity_type: entity_type,
          entity_id: entity_id,
          old_values: old_values,
          new_values: new_values
        }
      }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

      case res.code.to_i
      when 201
        true
      when 422
        raise StandardError, "Invalid audit log data: #{res.body}"
      else
        raise StandardError, "Unexpected error: #{res.code} - #{res.body}"
      end
    end
  end
end

