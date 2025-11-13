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
            doctor_detail_body = response.body["doctor_detail"]

            @doctor = Doctor.new(
              id: doctor_detail_body["doctor_id"],
              full_name: doctor_detail_body["full_name"],
              gender: doctor_detail_body["gender"],
              date_of_birth: doctor_detail_body["date_of_birth"],
              contact_number: doctor_detail_body["contact_number"],
              address: doctor_detail_body["address"]
            )
  
            true
          end
        end
      end
    end
  end
end
