module Api
  module Doctors
    class BaseController < ApplicationController
      before_action :require_doctor!

      private

      def set_patient
        return unless params[:id].present?

        user = ::ExternalServices::UsersService.get_user(params[:id])
        return render_patient_not_found unless user&.patient?
        return render_patient_not_found unless assigned_to_patient?(user.id)

        @patient = user
      rescue UserNotFound
        render_patient_not_found
      rescue Unauthorized
        render(status: :unauthorized, json: { errors: ['Unauthorized access'] })
      rescue StandardError => e
        render(status: :internal_server_error, json: { errors: [e.message] })
      end

      # Confirms the current doctor actually has an appointment relationship with this
      # patient, via appointments_service — patient existence alone isn't authorization.
      def assigned_to_patient?(patient_id)
        patient_ids_service.call && patient_ids_service.patient_ids.include?(patient_id.to_i)
      end

      def patient_ids_service
        @patient_ids_service ||= ::ExternalServices::AppointmentsService::PatientIds.new(auth_token:)
      end

      def render_patient_not_found
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def auth_token
        request.headers['Authorization']
      end
    end
  end
end
