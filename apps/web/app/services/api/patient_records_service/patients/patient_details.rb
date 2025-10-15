module Api
  module PatientRecordsService
    module Patients
      class PatientDetails < ApplicationService
        attr_reader :patient

        def call
          return false if auth_token.blank?

          url = "#{SERVICE_URL}/patients/details"
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def auth_token
          cookies.signed[:auth_token]
        end

        def handle_response(response)
          return handle_success(response) if response.status.eql?(200)
          
          response.body["errors"].each do |error|
            errors.add(:base, error)
          end

          false
        end

        def handle_success(response)
          patient_details = response.body["patient_detail"]

          @patient = User.new(
            full_name: patient_details["full_name"],
            gender: patient_details["gender"],
            date_of_birth: patient_details["date_of_birth"],
            contact_number: patient_details["contact_number"],
            address: patient_details["address"]
          )

          true
        end
      end
    end
  end
end
