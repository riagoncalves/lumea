module Api
  module AppointmentsService
    module Appointments
      class Complete < Api::AppointmentsService::Base
        attribute :id, :integer

        def call
          response = Faraday.put(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/appointments/#{id}/complete"
        end

        def handle_response(response)
          return true if response.success?
          
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
