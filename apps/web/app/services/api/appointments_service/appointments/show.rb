module Api
  module AppointmentsService
    module Appointments      
      class Show < Api::AppointmentsService::Base
        attribute :id, :integer
  
        attr_reader :appointment
        def call
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/appointments/#{id}"
        end

        def handle_response(response)
          return handle_success(response) if response.status.eql?(200)
          
          if response.body["errors"].present?
            response.body["errors"].each do |error|
              errors.add(:base, error)
            end
          else
            errors.add(:base, "Unexpected error occurred.")
          end

          false
        end

        def handle_success(response)
          appointment_data = response.body["appointment"]

          @appointment = Appointment.new(
              id: appointment_data["id"],
              status: appointment_data["status"],
              start_time: appointment_data["start_time"],
              end_time: appointment_data["end_time"],
              created_at: appointment_data["created_at"],
              updated_at: appointment_data["updated_at"],
              doctor_id: appointment_data["doctor_id"],
              patient_id: appointment_data["patient_id"],
              doctor: Doctor.new(
                id: appointment_data.dig("doctor", "doctor_id"),
                full_name: appointment_data.dig("doctor", "full_name")
              )
            )

          true
        end
      end
    end
  end
end

