module Api
  module AppointmentsService
    module Appointments
      class Create < Api::AppointmentsService::Base
        attribute :doctor_id, :integer
        attribute :start_time, :datetime
        attribute :end_time, :datetime

        def call
          response = Faraday.post(url) do |req|
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
          "#{SERVICE_URL}/appointments/create"
        end

        def handle_response(response)
          return true if response.status.eql?(201)
          
          response.body["errors"].each do |error|
            errors.add(:base, error)
          end

          false
        end
      end
    end
  end
end
