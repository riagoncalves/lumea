module ExternalServices
  module AppointmentsService
    class PatientIds < ApplicationService
      attribute :auth_token, :string

      attr_reader :patient_ids

      def call
        response = Faraday.get(url) do |req|
          req.headers['Authorization'] = auth_token
        end

        handle_response(response)
      end

      private

      def url
        "#{ENV['APPOINTMENTS_SERVICE_URL']}/doctors/patients"
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
        @patient_ids = response.body.dig('patients', 'patient_ids')&.map(&:to_i) || []

        true
      end
    end
  end
end
