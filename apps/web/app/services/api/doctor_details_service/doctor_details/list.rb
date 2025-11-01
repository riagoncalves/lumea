module Api
  module DoctorDetailsService
    module DoctorDetails
      class List < Api::DoctorDetailsService::Base
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

        attr_reader :doctors

        def call
          return false if INTERNAL_API_SECRET.blank?

          url = "#{SERVICE_URL}/public/doctor_details"
          response = Faraday.get(url) do |req|
            req.headers['Authorization'] = INTERNAL_API_SECRET
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
          doctor_details_body = response.body["doctor_details"]

          @doctors = doctor_details_body.map do |doctor_detail|
            Doctor.new(
              id: doctor_detail["doctor_id"],
              full_name: doctor_detail["full_name"],
            )
          end

          true
        end
      end
    end
  end
end
