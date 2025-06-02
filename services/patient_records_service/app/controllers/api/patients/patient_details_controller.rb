module Api
  module Patients
    class PatientDetailsController < ApplicationController
      def show
        render(status: :ok,
              json: patient_detail,
              serializer: ::PatientDetailsSerializer,
              root: :patient_detail,
              adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient detail not found'] })
      end

      def update
        if patient_detail.update(patient_detail_params)
          render(status: :ok,
                json: patient_detail,
                serializer: ::PatientDetailsSerializer,
                root: :patient_detail,
                adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: patient_detail.errors.full_messages })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient detail not found'] })
      end

      private

      def patient_detail
        @patient_detail ||= PatientDetail.find_or_initialize_by(patient_id: current_user.id)
      end

      def patient_detail_params
        params.require(:patient_detail).permit(:full_name, :gender, :date_of_birth, :contact_number, :address)
      end
    end
  end
end
