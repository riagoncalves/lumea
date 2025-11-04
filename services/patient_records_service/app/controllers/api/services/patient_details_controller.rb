module Api
  module Services
    class PatientDetailsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :app_authentication!

      def show
        render(status: :ok,
              json: patient_detail,
              serializer: ::PatientDetailsMinimalSerializer,
              root: :patient_detail,
              adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient detail not found'] })
      end
      private

      def patient_detail
        return @patient_detail if defined?(@patient_detail)

        @patient_detail = PatientDetail.find_or_initialize_by(patient_id: params[:patient_id])
      end
    end
  end
end
