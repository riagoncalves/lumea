module Api
  module AppointmentsService
    module Appointments
      class Update < Api::AppointmentsService::Base
        attribute :id, :integer
        attribute :doctor_id, :integer
        attribute :start_time, :datetime
        attribute :end_time, :datetime

        def call
          response = Faraday.put(url) do |req|
            req.headers['Authorization'] = auth_token
            req.body = {
              appointment: {
                start_time:,
                end_time:,
                doctor_id:
              }
            }
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/appointments/#{id}"
        end

        def handle_response(response)
          return true if response.status.eql?(200)
          
          if response.body["errors"].present?
            response.body["errors"].each do |error|
              errors.add(:base, error)
            end
          else
            errors.add(:base, "Unexpected error occurred.")
          end

          false
        end
      end
    end
  end
end
