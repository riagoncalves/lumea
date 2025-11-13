module Api
  module PatientRecordsService
    module Doctors
      module PatientDetails
        class Show < PatientRecordsService::Base
          attribute :patient_id, :integer
          attribute :auth_token, :string
  
          attr_reader :patient
  
          def call
            return false if auth_token.blank?
  
            response = Faraday.get(url) do |req|
              req.headers['Authorization'] = auth_token
            end
  
            handle_response(response)
          end
  
          private

          def url
            "#{SERVICE_URL}/doctors/patient_details/#{patient_id}"
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
            patient_detail = response.body["patient_detail"]
            
            @patient = Patient.new(
              id: patient_detail["patient_id"],
              full_name: patient_detail["full_name"],
              gender: patient_detail["gender"],
              date_of_birth: patient_detail["date_of_birth"],
              contact_number: patient_detail["contact_number"],
              address: patient_detail["address"]
            )
  
            true
          end
        end
      end
    end
  end
end
