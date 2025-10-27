module ExternalServices
  module DoctorDetailsService
    class Show < ApplicationService
      INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

      attribute :doctor_id, :integer

      attr_reader :doctor

      def call
        response = Faraday.get(url) do |req|
          req.headers['Authorization'] = INTERNAL_API_SECRET
        end

        handle_response(response)
      end

      private

      def url
        "#{ENV['DOCTOR_DETAILS_SERVICE_URL']}/public/doctor_details/#{doctor_id}"
      end

      def handle_response(response)
        return handle_success(response) if response.status.eql?(200)
        
        response.body["errors"].each do |error|
          errors.add(:base, error)
        end

        false
      end

      def handle_success(response)
        @doctor = response.body["doctor_detail"].tap do |doctor_detail_data|
          {
            id: doctor_detail_data["doctor_id"]&.to_i,
            name: doctor_detail_data["full_name"]
          }
        end

        true
      end
    end
  end
end
