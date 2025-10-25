module Api
  module AppointmentsService
    module Appointments
      class Cancel < Api::AppointmentsService::Base
        attribute :id, :integer

        def call
          response = Faraday.delete(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/appointments/#{id}/cancel"
        end

        def handle_response(response)
          return true if response.status.eql?(200)
          
          response.body["errors"].each do |error|
            errors.add(:base, error)
          end

          false
        end
      end
    end
  end
end
