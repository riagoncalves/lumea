module Api
  module DoctorDetailsService
    module Doctors
      module DoctorDetails
        class Show < Api::DoctorDetailsService::Base
          attribute :auth_token, :string
  
          attr_reader :doctor
  
          def call
            return false if auth_token.blank?
  
            url = "#{SERVICE_URL}/doctors/doctor_details"
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
            @doctor = response.body["doctor_detail"].tap do |doctor_detail|
              Doctor.new(
                id: doctor_detail["doctor_id"],
                full_name: doctor_detail["full_name"],
                gender: doctor_detail["gender"],
                date_of_birth: doctor_detail["date_of_birth"],
                contact_number: doctor_detail["contact_number"],
                address: doctor_detail["address"]
              )
            end
  
            true
          end
        end
      end
    end
  end
end
