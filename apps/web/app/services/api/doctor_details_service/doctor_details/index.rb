module Api
  module DoctorDetailsService
    module DoctorsDetails
      class Index < DoctorDetailsService::Base
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

        attr_reader :doctor_details

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
          return handle_success(response) if response.status.eql?(200)
          
          response.body["errors"].each do |error|
            errors.add(:base, error)
          end

          false
        end

        def handle_success(response)
          doctor_details_body = response.body["doctor_details"]

          @doctor_details = doctor_details_body.map do |doctor_detail|
            User.new(
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
