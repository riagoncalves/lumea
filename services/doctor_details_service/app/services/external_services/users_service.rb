require 'net/http'
require 'uri'
require 'json'

module ExternalServices
  class UsersService
    USERS_SERVICE_URL = ENV.fetch("USERS_SERVICE_URL")
    INTERNAL_API_SECRET = ENV.fetch("APP_SECRET_KEY")

    def self.get_current_user(token)
      uri = URI("#{USERS_SERVICE_URL}/api/users/me")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = token

      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

      case res.code.to_i
      when 200
        User.new(JSON.parse(res.body)['user'])
      when 401
        raise Unauthorized, "Invalid or expired token"
      else
        raise StandardError, "Unexpected error: #{res.code} - #{res.body}"
      end
    end

    def self.get_user(user_id)
      uri = URI("#{USERS_SERVICE_URL}/api/external_services/users/#{user_id}")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = INTERNAL_API_SECRET

      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

      case res.code.to_i
      when 200
        User.new(JSON.parse(res.body)['user'])
      when 404
        raise UserNotFound, "User #{user_id} not found"
      when 403
        raise Unauthorized, "Invalid internal auth"
      else
        raise StandardError, "Unexpected error: #{res.code} - #{res.body}"
      end
    end
  end
end
