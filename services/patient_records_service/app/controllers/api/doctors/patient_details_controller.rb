module Api
  module Doctors
    class PatientDetailsController < BaseController
      before_action :set_patient, only: [:show, :update]

      def index
        if patient_ids_service.call
          patient_details = PatientDetail.where(patient_id: patient_ids_service.patient_ids)
          render(status: :ok,
                 json: patient_details,
                 each_serializer: ::PatientDetailsMinimalSerializer,
                 root: :patient_details,
                 adapter: :json)
        else
          render(status: :unauthorized, json: { errors: patient_ids_service.errors.full_messages })
        end
      end

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

      def patient_ids_service
        @patient_ids_service ||= ExternalServices::AppointmentsService::PatientIds.new(auth_token:)
      end
    end
  end
end
