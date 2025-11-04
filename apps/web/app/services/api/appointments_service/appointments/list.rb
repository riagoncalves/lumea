module Api
  module AppointmentsService
    module Appointments      
      class List < Api::AppointmentsService::Base
        attr_reader :appointments

        def call
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/appointments"
        end

        def handle_response(response)
          return handle_success(response) if response.success?
          
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
          @appointments = response.body["appointments"].map do |appointment_data|
            Appointment.new(
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
              ),
              patient: Patient.new(
                id: appointment_data.dig("patient", "patient_id"),
                full_name: appointment_data.dig("patient", "full_name")
              ),
              can_start_video_call: appointment_data["can_start_video_call"]
            )
          end

          true
        end
      end
    end
  end
end

