module Api
  module Doctors
    class PatientDetailsController < ApplicationController
      before_action :require_doctor!
      before_action :set_patient, only: [:show, :update]

      def show
        if @patient.present?
          render(status: :ok,
                json: patient_detail,
                serializer: ::PatientDetailsSerializer,
                root: :patient_detail,
                adapter: :json)
        else
          render(status: :not_found, json: { errors: ['Patient not found or is not a valid patient'] })
        end
      end
  
      def update
        if @patient.present?
          if patient_detail.update(patient_detail_params)
            render(status: :ok,
                  json: patient_detail,
                  serializer: ::PatientDetailsSerializer,
                  root: :patient_detail,
                  adapter: :json)
          else
            render(status: :unprocessable_entity, json: { errors: patient_detail.errors.full_messages })
          end
        else
          render(status: :not_found, json: { errors: ['Patient not found or is not a valid patient'] })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient detail not found'] })
      end
  
      private
  
      def patient_detail
        @patient_detail ||= PatientDetail.find_or_initialize_by(patient_id: @patient.id)
      end
  
      def patient_detail_params
        params.require(:patient_detail).permit(:full_name, :gender, :date_of_birth, :contact_number, :address)
      end

      def set_patient
        return unless params[:id].present?

        user = ::ExternalServices::UsersService.get_user(params[:id])
        return unless user&.patient?

        @patient = user
      rescue UserNotFound
        raise ActiveRecord::RecordNotFound, 'Patient not found'
      rescue Unauthorized
        render(status: :unauthorized, json: { errors: ['Unauthorized access'] })
      rescue StandardError => e
        render(status: :internal_server_error, json: { errors: [e.message] })
      end
    end
  end
end
