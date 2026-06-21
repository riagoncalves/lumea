module ExternalServices
  module PatientRecordsService
    module PatientDetails
      class Show < ApplicationService
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]
  
        attribute :patient_id, :integer

        attr_reader :patient

        def call
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = INTERNAL_API_SECRET
          end
  
          handle_response(response)
        end
  
        private
  
        def url
          "#{ENV['PATIENT_RECORDS_SERVICE_URL']}/api/services/patient_details/#{patient_id}"
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
          @patient = response.body["patient_detail"].tap do |patient_detail_data|
            {
              id: patient_detail_data["patient_id"]&.to_i,
              name: patient_detail_data["full_name"]
            }
          end
  
          true
        end
      end
    end
  end
end
