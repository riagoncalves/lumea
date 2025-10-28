module Api
  module PatientRecordsService
    module Patients
      class PatientDetails < PatientRecordsService::Base
        attribute :auth_token, :string

        attr_reader :patient

        def call
          return false if auth_token.blank?

          url = "#{SERVICE_URL}/patients/patient_details"
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

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
