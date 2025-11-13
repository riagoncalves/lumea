module Api
  module PatientRecordsService
    module Patients
      module PatientDetails
        class Update < PatientRecordsService::Base
          attribute :auth_token, :string
          attribute :full_name, :string
          attribute :gender, :string
          attribute :date_of_birth, :date
          attribute :contact_number, :string
          attribute :address, :string
  
          attr_reader :patient
  
          def call
            return false if auth_token.blank?
  
            response = Faraday.put(url) do |req|
              req.headers['Authorization'] = auth_token
              req.body = {
                patient_detail: {
                  full_name:,
                  gender:,
                  date_of_birth:,
                  contact_number:,
                  address:
                }
              }
            end
  
            handle_response(response)
          end
  
          private

          def url
            "#{SERVICE_URL}/patients/patient_details/update"
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
            true
          end
        end
      end
    end
  end
end
