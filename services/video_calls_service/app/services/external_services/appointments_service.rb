require 'net/http'
require 'uri'
require 'json'

module ExternalServices
  class AppointmentsService
    APPOINTMENTS_SERVICE_URL = ENV.fetch("APPOINTMENTS_SERVICE_URL")
    INTERNAL_API_SECRET = ENV.fetch("APP_SECRET_KEY")

    def self.can_start_video_call?(appointment_id)
      uri = URI("#{APPOINTMENTS_SERVICE_URL}/api/public/appointments/#{appointment_id}")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = INTERNAL_API_SECRET

      res = Net::HTTP.start(uri.hostname, uri.port, open_timeout: 2, read_timeout: 5) { |http| http.request(req) }

      res.code.to_i == 200 && JSON.parse(res.body)['can_start_video_call'] == true
    rescue StandardError => e
      Rails.logger.error("Failed to verify appointment #{appointment_id} for video call: #{e.message}")
      false
    end
  end
end
