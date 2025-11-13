module Api
  module PatientRecordsService
    module Doctors
      module PatientDetails
        class List < PatientRecordsService::Base
          attribute :auth_token, :string
  
          attr_reader :patients
  
          def call
            return false if auth_token.blank?
  
            response = Faraday.get(url) do |req|
              req.headers['Authorization'] = auth_token
            end
  
            handle_response(response)
          end
  
          private

          def url
            "#{SERVICE_URL}/doctors/patient_details"
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
            patient_details = response.body["patient_details"]
            
            @patients = patient_details.map do |patient_detail|
              Patient.new(
                id: patient_detail["patient_id"],
                full_name: patient_detail["full_name"],
              )
            end
  
            true
          end
        end
      end
    end
  end
end
